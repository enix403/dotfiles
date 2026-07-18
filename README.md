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
│   ├── gitui/       # gitui theme (ANSI-following, tracks the terminal palette)
│   ├── kitty/       # Kitty terminal config (with parts/ for modular includes)
│   ├── mise/        # mise runtime version manager config
│   ├── nvim/        # Neovim config (LazyVim-based)
│   ├── omz/         # Zsh config: aliases/paths/vars, lib/, vendored thirdparty/
│   ├── starship/    # Starship prompt config
│   ├── tinty/       # tinty config (base16/base24 theme manager, drives kitty)
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
└── install-linux.sh   # Linux bootstrap script (WIP)
```

## Notable components

### Shell (plain Zsh)

Config lives in `shared/zsh/` (`.zshenv`, `.zshrc`, `.zprofile` symlinked into `~`).
No framework — Oh My Zsh was removed in favor of plain zsh; the prompt is
[Starship](https://starship.rs/).

The config is split into **base** (every shell — interactive, scripts, `zsh -c`,
cron, ssh commands) and **interactive** (prompt sessions only), matching zsh's own
startup-file model:

- **`.zshenv`** → base. Sets `typeset -U PATH`, then sources `config/base.*.zsh`.
  Symlinked to `~/.zshenv` (replaces the former KTMR-managed file; `brew shellenv`
  now lives in `config/base.paths.10-default.zsh`, repo-owned).
- **`.zshrc`** → interactive. History, `compinit`, completion, keybindings, plugins,
  aliases, Starship. Sources `config/int.*.zsh`. zsh always reads `.zshenv` first,
  so this file assumes base is already loaded.

Config files under `shared/zsh/config/` are auto-sourced by glob loops in filename
order, keyed on a `base.` / `int.` scope marker:

- `base.paths.10-default.zsh` — PATH setup (Homebrew via `brew shellenv`, mise, pyenv, bun, cargo)
- `base.vars.10-default.zsh` — exported variables (EDITOR, PAGER, …)
- `int.aliases.10-default.zsh` — core aliases and functions
- `int.aliases.11-work.local.zsh` — work-specific aliases (not committed)

Machine-local overrides use the same scope prefix and are gitignored: `base.x-*.zsh`,
`int.x-*.zsh` (symlinks into a private repo, synced by that repo's `shsync`) and
`*.local.zsh`.

`config/` holds only autoloaded files (the glob-sourced `base.*`/`int.*`). Vendored
code lives beside it under `shared/zsh/` and is sourced explicitly by `.zshrc`:

`shared/zsh/lib/` holds small self-contained pieces vendored from Oh My Zsh's `lib/`
(nav aliases + `auto_pushd`, interactive keybindings, completion `zstyle`s).

`shared/zsh/thirdparty/` holds all vendored third-party zsh code (plain committed
files — no submodules):
- `fzf-tab/` — replaces zsh tab completion with fzf
- `zsh-syntax-highlighting/` — syntax highlighting in the prompt (sourced last)
- `colored-man-pages/` — colorized man pages
- `zsh-window-title.zsh` — informative terminal window titles

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

### Theming (unified via `settheme`)

One command reskins the whole terminal environment:

```bash
settheme            # list themes (current marked with *)
settheme gruvbox    # apply a theme everywhere
```

Available: `catppuccin-mocha` (default), `tokyo-night`, `gruvbox`, `rose-pine`, `nord`.

The design is a **hybrid**: instead of hardcoding a palette in every tool, kitty
is the single source of the 16 ANSI colors and most tools just *follow* it.

- **kitty** — its palette is set by [`tinty`](https://github.com/tinted-theming/tinty)
  (a base16/base24 theme manager). `settheme` runs `tinty apply`, which writes a
  gitignored `kitty/theme.conf` (`globinclude`d, so `parts/colors.conf` stays the
  committed fallback) and live-reloads every running window via `$KITTY_LISTEN_ON`.
  base24 schemes are preferred where available (truer bright colors), else base16.
- **bat, fzf, starship, gitui** — configured to follow the 16 ANSI colors,
  so they track kitty automatically with **no per-theme config**. `bat --theme=base16`,
  `fzf --color=16`, starship's named colors, and gitui's `ansi.ron`.
- **delta** — intentionally left out of the theme flow. It keeps its own fixed
  `mantis-shrimp` diff theme (from `delta/themes.gitconfig`), independent of the
  terminal palette.
- **nvim, yazi** — keep native theme ports. `settheme` writes the nvim colorscheme
  to a gitignored `nvim/lua/config/colorscheme.lua` and repoints the yazi flavor in
  `yazi/theme.toml`. Open a new nvim/yazi to pick up the change.

The theme registry (name → tinty scheme / nvim colorscheme / yazi flavor) lives in
`shared/bin/settheme`. **Adding more themes** is a short, repeatable process —
see [`shared/tinty/ADDING-THEMES.md`](shared/tinty/ADDING-THEMES.md) for the full
runbook (with a worked example and the yazi-flavor gotchas).

**Setup on a new machine:** `brew install tinty` (or your package manager), run
`shared/_apply/link-dots.sh` to symlink configs, then `tinty install` and
(from `shared/yazi/`) `ya pkg install` to fetch schemes and flavors.

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
| `settheme` | Switch the terminal theme across all tools at once (see [Theming](#theming-unified-via-settheme)) |
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
