#!/usr/bin/env bash
# Symlink the cross-platform configs. Safe to re-run; see link() in lib.sh.
set -euo pipefail
source "$(dirname "$0")/lib.sh"
S="$DOTFILES/shared"

# ~
link "$S/bin"            ~/bin
link "$S/.gitconfig"     ~/.gitconfig
# zsh startup files: .zshenv holds the base config (all shells), .zshrc is
# interactive-only.
link "$S/zsh/.zshenv"    ~/.zshenv
link "$S/zsh/.zprofile"  ~/.zprofile
link "$S/zsh/.zshrc"     ~/.zshrc

# ~/.config
for app in alacritty bat delta dcg gitui kitty lode nvim starship yazi; do
    link "$S/$app" ~/.config/$app
done
# yazi/theme.toml holds only the active flavor and is a gitignored runtime
# artifact (written by settheme). Seed it from the committed default on a fresh
# clone so yazi has a flavor before the first `settheme` run.
[ -f "$S/yazi/theme.toml" ] || cp "$S/yazi/theme.toml.default" "$S/yazi/theme.toml"

# mise: a conf.d drop-in, so a machine-local ~/.config/mise/config.toml can
# exist alongside it (and wins on conflicts).
link "$S/mise/config.toml" ~/.config/mise/conf.d/personal.toml

# IPython
link "$S/ipython/profile_default/ipython_config.py" ~/.ipython/profile_default/ipython_config.py
link "$S/ipython/themes"                            ~/.ipython/themes

# Claude Code: ~/.claude is assembled from layered config dirs; see shared/bin/claude-layers
if command -v claude >/dev/null; then
    link "$S/claude/claude-powerline.json" ~/.claude/claude-powerline.json
    "$S/bin/claude-layers" || echo "warning: claude-layers failed; fix and re-run it" >&2
fi
