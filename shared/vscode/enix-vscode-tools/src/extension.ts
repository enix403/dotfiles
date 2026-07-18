import * as vscode from 'vscode';
import * as path from 'path';
import { execFile } from 'child_process';

const CLOSING: Record<string, string> = { '(': ')', '[': ']', '{': '}', '<': '>' };

function getContentRange(lines: string[]): [number, number] {
    let start = 0, end = lines.length - 1;
    while (start <= end && lines[start].trim() === '') { start++; }
    while (end >= start && lines[end].trim() === '') { end--; }
    return [start, end];
}

function applyToContent(lines: string[], fn: (content: string[]) => string[]): string[] {
    const [start, end] = getContentRange(lines);
    if (start > end) { return lines; }
    return [
        ...lines.slice(0, start),
        ...fn(lines.slice(start, end + 1)),
        ...lines.slice(end + 1),
    ];
}

function selectedLines(editor: vscode.TextEditor): string[] | null {
    if (editor.selection.isEmpty) {
        vscode.window.showWarningMessage('Select a block of text first.');
        return null;
    }
    return editor.document.getText(editor.selection).split('\n');
}

export function activate(context: vscode.ExtensionContext) {
    const git = (dir: string, args: string[]): Promise<string> =>
        new Promise((resolve, reject) =>
            execFile('git', ['-C', dir, ...args], (err, stdout, stderr) =>
                err ? reject(new Error(stderr.trim() || err.message)) : resolve(stdout.trim())
            )
        );

    const joinLines = vscode.commands.registerCommand('enix-vscode-tools.joinLinesWithSeparator', async () => {
        const editor = vscode.window.activeTextEditor;
        const lines = editor ? selectedLines(editor) : null;
        if (!editor || !lines) { return; }

        const separator = await vscode.window.showInputBox({ prompt: 'Join lines with', value: ',' });
        if (separator === undefined) { return; }

        const result = applyToContent(lines, content => [content.map(l => l.trim()).join(separator)]);
        await editor.edit(edit => edit.replace(editor.selection, result.join('\n')));
    });

    const splitIntoLines = vscode.commands.registerCommand('enix-vscode-tools.splitSelectionIntoLines', () => {
        const editor = vscode.window.activeTextEditor;
        const lines = editor ? selectedLines(editor) : null;
        if (!editor || !lines) { return; }

        const [start] = getContentRange(lines);
        const selectionStartLine = editor.selection.start.line;

        const [contentStart, contentEnd] = getContentRange(lines);
        const cursors: vscode.Selection[] = [];
        for (let i = contentStart; i <= contentEnd; i++) {
            const pos = new vscode.Position(selectionStartLine + i, 0);
            cursors.push(new vscode.Selection(pos, pos));
        }
        editor.selections = cursors;
    });

    const wrapLines = vscode.commands.registerCommand('enix-vscode-tools.wrapLines', async () => {
        const editor = vscode.window.activeTextEditor;
        const lines = editor ? selectedLines(editor) : null;
        if (!editor || !lines) { return; }

        const wrapper = await vscode.window.showInputBox({ prompt: 'Wrap each line with', value: '"' });
        if (wrapper === undefined) { return; }

        const open = wrapper;
        const close = CLOSING[wrapper] ?? wrapper;
        const result = applyToContent(lines, content => content.map(l => `${open}${l}${close}`));
        await editor.edit(edit => edit.replace(editor.selection, result.join('\n')));
    });

    const appendToLines = vscode.commands.registerCommand('enix-vscode-tools.appendToLines', async () => {
        const editor = vscode.window.activeTextEditor;
        const lines = editor ? selectedLines(editor) : null;
        if (!editor || !lines) { return; }

        const suffix = await vscode.window.showInputBox({ prompt: 'Append to each line', value: ',' });
        if (suffix === undefined) { return; }

        const result = applyToContent(lines, content => content.map(l => `${l}${suffix}`));
        await editor.edit(edit => edit.replace(editor.selection, result.join('\n')));
    });

    const mdclip = vscode.commands.registerCommand('enix-vscode-tools.mdclip', async () => {
        const editor = vscode.window.activeTextEditor;
        if (!editor || editor.selection.isEmpty) {
            vscode.window.showWarningMessage('Select a block of text first.');
            return;
        }

        const text = editor.document.getText(editor.selection);
        await vscode.env.clipboard.writeText(text);

        await new Promise<void>(resolve => {
            const proc = execFile('mdclip', [], (error) => {
                if (error) {
                    const msg = (error as { code?: string }).code === 'ENOENT'
                        ? 'mdclip: command not found'
                        : `mdclip failed: ${error.message}`;
                    vscode.window.showWarningMessage(msg);
                }
                resolve();
            });
            proc.stdin?.end(text);
        });
    });

    const copyGithubUrl = vscode.commands.registerCommand('enix-vscode-tools.copyGithubUrl', async () => {
        const editor = vscode.window.activeTextEditor;
        if (!editor) {
            vscode.window.showWarningMessage('No active file.');
            return;
        }

        const filePath = editor.document.uri.fsPath;
        const dir = path.dirname(filePath);

        let gitRoot: string;
        try {
            gitRoot = await git(dir, ['rev-parse', '--show-toplevel']);
        } catch {
            vscode.window.showErrorMessage('File is not in a git repository.');
            return;
        }

        let remoteUrl: string;
        try {
            remoteUrl = await git(dir, ['remote', 'get-url', 'origin']);
        } catch {
            vscode.window.showErrorMessage('Could not determine GitHub remote (no origin remote).');
            return;
        }

        const match = remoteUrl.match(/github\.com[:/]([^/]+)\/([^/.]+)/);
        if (!match) {
            vscode.window.showErrorMessage('Remote origin is not a GitHub repository.');
            return;
        }
        const [, username, repoName] = match;

        const branch = await git(dir, ['rev-parse', '--abbrev-ref', 'HEAD']);
        const relativePath = path.relative(gitRoot, filePath).split(path.sep).join('/');

        const url = `https://github.com/${username}/${repoName}/tree/${branch}/${relativePath}`;
        await vscode.env.clipboard.writeText(url);
        vscode.window.showInformationMessage(`Copied: ${url}`);
    });

    context.subscriptions.push(joinLines, splitIntoLines, wrapLines, appendToLines, mdclip, copyGithubUrl);
}

export function deactivate() {}
