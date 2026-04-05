#!/usr/bin/env bash

## Custom fonts stored in: ~/.local/share/fonts/custom_*

mkd -p ~/.local/share/fonts

# ======= FiraCode Nerd Font ======

cd /tmp
# replace with latest link
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip
unzip FiraCode.zip -d ~/.local/share/fonts/custom_nerd_firacode
fc-cache -fv
rm FiraCode.zip