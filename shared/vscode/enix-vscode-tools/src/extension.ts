import * as vscode from 'vscode';

export function activate(context: vscode.ExtensionContext) {
    const helloWorld = vscode.commands.registerCommand('enix-vscode-tools.helloWorld', () => {
        vscode.window.showInformationMessage('Hello from enix-vscode-tools!');
    });

    const joinLines = vscode.commands.registerCommand('enix-vscode-tools.joinLinesWithSeparator', async () => {
        const editor = vscode.window.activeTextEditor;
        if (!editor || editor.selection.isEmpty) {
            vscode.window.showWarningMessage('Select a block of text first.');
            return;
        }

        const separator = await vscode.window.showInputBox({
            prompt: 'Join lines with',
            value: ',',
            placeHolder: ',',
        });

        if (separator === undefined) {
            return;
        }

        const selection = editor.selection;
        const text = editor.document.getText(selection);
        const lines = text.split('\n').map(l => l.trim());
        let start = 0;
        let end = lines.length - 1;
        while (start <= end && lines[start] === '') { start++; }
        while (end >= start && lines[end] === '') { end--; }
        const joined = lines.slice(start, end + 1).join(separator);

        await editor.edit(edit => edit.replace(selection, joined));
    });

    context.subscriptions.push(helloWorld, joinLines);
}

export function deactivate() {}
