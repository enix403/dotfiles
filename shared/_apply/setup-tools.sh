#!/usr/bin/env bash
# Install runtimes/tools and build caches. Run after link-dots.sh. Safe to re-run.
set -euo pipefail
source "$(dirname "$0")/lib.sh"

# Runtimes and CLIs from shared/mise/config.toml (node, pnpm, yarn, uv, ...)
mise install

# pylab: the venv behind the py/ipy/jl aliases. A machine can point
# ~/.local/share/pylab at a different venv; an existing one is left alone.
if [ -e ~/.local/share/pylab ] || [ -L ~/.local/share/pylab ]; then
    echo "keep    ~/.local/share/pylab (-> $(readlink ~/.local/share/pylab || echo 'not a symlink'))"
else
    (cd "$DOTFILES/shared/pylab" && mise exec -- uv sync)
    link "$DOTFILES/shared/pylab/.venv" ~/.local/share/pylab
fi

# Register the bundled bat .tmTheme files
if command -v bat >/dev/null; then
    bat cache --build
fi
