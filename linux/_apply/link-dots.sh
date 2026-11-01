#!/usr/bin/env bash
# Symlink the Linux-only configs. Safe to re-run.
set -euo pipefail
source "$(dirname "$0")/../../shared/_apply/lib.sh"

link "$DOTFILES/linux/zathura" ~/.config/zathura
