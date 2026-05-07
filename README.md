# dotfiles

Personal dotfiles for macOS and Linux (Fedora/GNOME), managed via symlinks.

## Structure

```
dotfiles/
├── shared/          # Cross-platform configs (symlinked into ~ and ~/.config)
│   ├── alacritty/   # Alacritty terminal config
│   ├── bat/         # bat (cat replacement) config
│   ├── bin/         # Custom scripts on PATH
│   ├── delta/       # git-delta pager config
│   ├── kitty/       # Kitty terminal config (with parts/ for modular includes)
│   ├── mise/        # mise runtime version manager config
│   ├── nvim/        # Neovim config (LazyVim-based)
│   ├── omz/         # Oh My Zsh custom dir (aliases, paths, plugins)
│   ├── starship/    # Starship prompt config
│   ├── vscode/      # VS Code settings (linux + macos variants) and extensions list
│   └── yazi/        # Yazi file manager config
├── macos/           # macOS-only configs
│   ├── aerospace/   # AeroSpace tiling window manager config
│   └── karabiner/   # Karabiner-Elements key remapping (generated via Python)
├── linux/           # Linux-only configs
│   ├── _retire/     # Archived configs (i3, polybar, rofi, picom)
│   ├── fonts/       # Font download script
│   ├── gnome/       # GNOME keybindings and settings scripts
│   └── zathura/     # Zathura PDF viewer config
├── oh-my-zsh-custom/  # Git submodules for OMZ plugins
│   └── plugins/
│       ├── fzf-tab                 # (submodule) fzf-powered tab completion
│       └── zsh-syntax-highlighting # (submodule) syntax highlighting
└── install-linux.sh   # Linux bootstrap script (WIP)
```

## Notable components

### Shell (Zsh + Oh My Zsh)

Aliases and functions are split across numbered files in `shared/omz/` for load ordering:

- `aliases.10-default.zsh` — core aliases and functions
- `paths.10-default.zsh` — PATH setup (Homebrew, mise, pyenv, bun, cargo)
- `vars.10-default.zsh` — exported variables
- `aliases.11-work.local.zsh` — work-specific aliases (not committed)

Plugins (git submodules):
- `fzf-tab` — replaces zsh tab completion with fzf
- `zsh-syntax-highlighting` — syntax highlighting in the prompt

### Neovim

LazyVim-based config at `shared/nvim/`. Plugins include:

- `blink.lua` — blink.cmp completion
- `lsp.lua` — LSP configuration
- `snacks.lua` — snacks.nvim UI utilities
- `noice.lua` — Noice UI
- `toggleterm.lua` — integrated terminal
- `treesj.lua` — split/join code blocks
- `vim-kitty-navigator.lua` — seamless Kitty↔Neovim pane navigation

### Kitty terminal

Config split into `parts/` for modular includes (fonts, colors, keybinds, etc). Includes a `pass_keys.py` script for passing keys through to Neovim.

### VS Code

- `macos-settings.jsonc` / `linux-settings.jsonc` — per-OS settings
- `extensions.txt` — extension list for bulk install
- `keybinds-gen/` — keybinding generation tooling

### AeroSpace (macOS)

Tiling window manager config at `macos/aerospace/aerospace.toml`.

### Karabiner-Elements (macOS)

Key remapping config at `macos/karabiner/`. The `karabiner.json` is **generated** — edit `keylib.py` (key definitions) and `genconfig.py` (rule generation), then run:

```bash
python macos/karabiner/genconfig.py
```

### Custom bin scripts

Located in `shared/bin/`, added to `PATH`:

| Script | Description |
|---|---|
| `tunix` | Convert timestamp strings (many formats) to Unix epoch seconds |
| `tiso` | Convert Unix epoch seconds to ISO 8601 UTC string |
| `pull_hp` / `push_hp` | Helpers for syncing a home project |

### mise (runtime manager)

Global tool versions pinned in `shared/mise/config.toml` (node, pnpm, python, yarn).

## Linux packages (Fedora)

Installed via `linux/_apply/fedora-install-packages.sh`:

**dnf:** neovim, zsh, kitty, bat, fzf, git-delta, jq, htop, ncdu, vlc, zathura, tokei, fastfetch, and more

**COPRs:** starship, glow, yazi, mise

**Manual installs** (documented in the script): bun, typst, ngrok, mongodb-compass, popsicle
