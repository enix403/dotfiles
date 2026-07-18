# Adding a terminal theme

How to add a new theme to the unified `settheme` setup. For the overall design,
see the [Theming section of the README](../../README.md#theming-unified-via-settheme).

## Mental model (why this is only 3 real steps)

`settheme` maps one friendly name to three things:

```
name | tinty-scheme | nvim-colorscheme | yazi-flavor
```

Everything else — **bat, delta, fzf, starship, gitui** — follows the terminal's
16 ANSI colors, so it re-themes automatically the moment kitty's palette changes.
You never touch those tools when adding a theme. You only wire up:

1. **kitty palette** — a `tinty` scheme (base16/base24)
2. **nvim** — a colorscheme plugin + its `:colorscheme` name
3. **yazi** — a flavor package

Then add one row to the registry in [`../bin/settheme`](../bin/settheme).

---

## Step 1 — kitty palette (tinty scheme)

Browse what tinty can apply:

```bash
tinty list                 # 500+ schemes, prefixed base16-/base24-
tinty list | grep -i nord  # find a family
tinty gallery              # interactive visual browser
```

Pick the scheme id. **Prefer the `base24-` variant if it exists** (truer bright /
ANSI colors); otherwise use `base16-`. Confirm it actually resolves:

```bash
tinty info base24-<name>   # exits 0 if valid, non-zero if not
tinty info base16-<name>
```

> If neither shows up, refresh the scheme list: `tinty update`.

⚠️ **`tinty info` is necessary but not sufficient.** It validates the scheme
_definition_ exists, but the palette is only applied if the **tinted-kitty
template ships a pre-built `.conf` for that exact id**. A scheme can pass
`tinty info` yet fail at apply time with "Theme does not exists for tinted-kitty".
Confirm the actual file exists before registering:
>
> ```bash
> ls ~/.local/share/tinted-theming/tinty/repos/tinted-kitty/colors | grep -i <name>
> ```
>
> (This is why `tokyo-night-day` uses `base16-tokyo-night-light` — the `base24-`
> variant validates but has no kitty build.)

## Step 2 — nvim colorscheme

Add the colorscheme plugin to [`../nvim/lua/plugins/theme.lua`](../nvim/lua/plugins/theme.lua)
in the "Colorscheme plugins" block:

```lua
{ "owner/repo", lazy = true },
```

Install it and find the exact name it registers:

```bash
nvim --headless "+Lazy! sync" +qa           # installs the plugin
# verify the colorscheme name loads (prints the resolved name or errors):
nvim --headless "+silent! colorscheme <name>" "+lua io.write(vim.g.colors_name or 'NONE')" +qa
```

Plugin colorscheme names are often not the repo name (e.g. `tokyonight.nvim`
registers `tokyonight-night`, `catppuccin/nvim` registers `catppuccin-mocha`).
Check the plugin's README.

## Step 3 — yazi flavor

From `shared/yazi/`, add the flavor (this also records it in `package.toml`):

```bash
cd ~/dotfiles/shared/yazi
ya pkg add <owner/repo>
```

The flavor **name** is the deployed directory name minus `.yazi`
(e.g. `flavors/gruvbox-dark.yazi` → `gruvbox-dark`).

⚠️ **Gotcha:** `ya pkg add` classifies flavor vs plugin per repo. Use a
**single-flavor repo** (one whose root has a `flavor.toml`). A multi-flavor repo
addressed with a subpackage (`owner/repo:variant`) gets **misfiled under
`[[plugin.deps]]`** and never deploys to `flavors/`. If that happens, remove the
bad `[[plugin.deps]]` entry from `package.toml` and find a single-flavor repo
instead. Good sources: the [awesome-yazi](https://github.com/AnirudhG07/awesome-yazi)
list and [yazi-rs/flavors `themes.md`](https://github.com/yazi-rs/flavors/blob/main/themes.md).

## Step 4 — register it

Add a row to `registry()` in [`../bin/settheme`](../bin/settheme):

```
name|tinty-scheme|nvim-colorscheme|yazi-flavor
```

Then test:

```bash
settheme <name>            # kitty repaints live; nvim/yazi update on next launch
```

Completion picks up the new name automatically (it reads `settheme --names`).

---

## Worked example: adding `kanagawa`

```bash
# 1. kitty palette — base24 doesn't exist, base16 does:
tinty list | grep -i kanagawa      # -> base16-kanagawa (use this)
tinty info base16-kanagawa         # exits 0 ✓

# 2. nvim — add to theme.lua:  { "rebelot/kanagawa.nvim", lazy = true },
nvim --headless "+Lazy! sync" +qa
nvim --headless "+silent! colorscheme kanagawa" "+lua io.write(vim.g.colors_name)" +qa   # -> kanagawa ✓

# 3. yazi flavor (single-flavor repo):
cd ~/dotfiles/shared/yazi && ya pkg add dangooddd/kanagawa   # -> flavors/kanagawa.yazi

# 4. registry row in shared/bin/settheme:
#    kanagawa|base16-kanagawa|kanagawa|kanagawa

settheme kanagawa
```

---

## Maintenance

```bash
tinty update                                   # refresh tinty schemes + templates
cd ~/dotfiles/shared/yazi && ya pkg upgrade    # update yazi flavors (re-pins package.toml)
nvim --headless "+Lazy! update" +qa            # update nvim colorscheme plugins
```

## Removing a theme

1. Delete its row from `registry()` in `../bin/settheme`.
2. (optional) `ya pkg remove <owner/repo>` from `shared/yazi/` and delete the
   nvim plugin line from `theme.lua`.

## Light themes

Light variants for **bright/sunny environments** are added exactly like any other
theme. Two are wired up (`catppuccin-latte`, `tokyo-night-day`). They're cheap
because they reuse plugins already installed for their dark siblings:

- **nvim** — a light variant of an existing plugin needs **no new plugin line**.
  `catppuccin-latte` is a variant of `catppuccin/nvim`, `tokyonight-day` of
  `tokyonight.nvim`, `rose-pine-dawn` of `rose-pine/neovim`. Just use the variant
  name as the `nvim-colorscheme` column.
- **kitty** — prefer the `base24-` light scheme where tinted-kitty ships it
  (`base24-catppuccin-latte` does; tokyo-night light only has `base16-tokyo-night-light`).
- **yazi** — `yazi-rs/flavors:catppuccin-latte` and
  `kalidyasin/yazi-flavors:tokyonight-day` both classify correctly as flavors.

⚠️ **gruvbox-light is deliberately not included.** `ellisonleao/gruvbox.nvim`
uses a single `gruvbox` colorscheme and switches light/dark via `vim.o.background`,
not via a distinct colorscheme name. Our `settheme`→nvim contract is a single
colorscheme string (`config.colorscheme`), so a `gruvbox` row can't express
"light". Supporting it would need `settheme` to also emit a `background` value and
`theme.lua` to honor it — not worth it while other light themes cover the need.

## Notes

- The committed `../kitty/parts/colors.conf` is the fresh-clone fallback (currently
  Catppuccin Mocha). `settheme` writes the active palette to the gitignored
  `kitty/theme.conf`, which `globinclude` layers on top.
- Runtime artifacts are gitignored: `kitty/theme.conf`,
  `nvim/lua/config/colorscheme.lua`. The active yazi flavor lives in the tracked
  `yazi/theme.toml` (so switching themes shows a diff there — that's expected).
- The current theme is recorded at `~/.local/state/settheme/current`.
