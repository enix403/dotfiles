# enix-vscode-tools

Custom VS Code extension for enix workflows.

## Installation

This extension is not published to the marketplace. Install it locally by symlinking the extension folder into VS Code's extensions directory:

```bash
ln -s /path/to/dotfiles/shared/vscode/enix-vscode-tools ~/.vscode/extensions/enix-vscode-tools
```

Then build the extension:

```bash
cd /path/to/dotfiles/shared/vscode/enix-vscode-tools
npm install
npm run compile
```

Restart VS Code. The extension will be loaded automatically on every subsequent launch.

To pick up code changes after editing `src/`, run `npm run compile` (or keep `npm run watch` running in the background).

## Commands

| Command | Description |
|---|---|
| `enix: join lines with separator` | Joins all lines in the selection into one, separated by a prompt-provided string (default `,`) |
| `enix: split selection into lines` | Places a cursor at the start of each line in the selection |
| `enix: wrap lines` | Wraps each line with a prompt-provided string (default `"`). If the input is `(`, `[`, `{`, or `<`, the appropriate closing bracket is used on the right side |
| `enix: append to lines` | Appends a prompt-provided string (default `,`) to the end of each line |

All commands ignore empty lines at the start and end of the selection.
