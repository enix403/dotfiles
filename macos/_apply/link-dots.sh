#!/usr/bin/env bash
# Symlink the macOS-only configs. Safe to re-run.
set -euo pipefail
source "$(dirname "$0")/../../shared/_apply/lib.sh"

link "$DOTFILES/macos/aerospace" ~/.config/aerospace
link "$DOTFILES/macos/karabiner" ~/.config/karabiner
link "$DOTFILES/linux/zathura"   ~/.config/zathura
