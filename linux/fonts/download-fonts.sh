#!/usr/bin/env bash
# Download fonts that aren't packaged for Fedora into ~/.local/share/fonts/custom_*.
# Safe to re-run: a font whose directory already exists is skipped.
# (Fira Code itself comes from the fira-code-fonts dnf package.)
set -euo pipefail

fonts_dir=~/.local/share/fonts

# fetch <dir name> <zip url>
fetch() {
    local dest="$fonts_dir/$1" tmp
    if [ -d "$dest" ]; then
        echo "skip    $dest (exists)"
        return 0
    fi
    tmp=$(mktemp -d)
    curl -fL --progress-bar -o "$tmp/font.zip" "$2"
    mkdir -p "$dest"
    unzip -q "$tmp/font.zip" -d "$dest"
    rm -r "$tmp"
    echo "fetched $dest"
}

# Bump the versions here to update (delete the custom_* dir first).
fetch custom_nerd_firacode https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip
fetch custom_maplemono     https://github.com/subframe7536/maple-font/releases/download/v7.9/MapleMono-TTF-AutoHint.zip

fc-cache -f "$fonts_dir"
