#!/usr/bin/env bash

## Custom fonts stored in: ~/.local/share/fonts/custom_*

mkd -p ~/.local/share/fonts

# ======= Fira Code ======

# comes pre-installed with fedora

# ======= Fira Code Nerd Font ======

cd /tmp
# replace with latest link
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip
unzip FiraCode.zip -d ~/.local/share/fonts/custom_nerd_firacode
fc-cache -fv
rm FiraCode.zip

# ======= Maple Mono ======

cd /tmp
# replace with latest link
wget https://github.com/subframe7536/maple-font/releases/download/v7.9/MapleMono-TTF-AutoHint.zip
unzip MapleMono-TTF-AutoHint.zip -d ~/.local/share/fonts/custom_maplemono
rm MapleMono-TTF-AutoHint.zip
