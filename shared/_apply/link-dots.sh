#!/usr/bin/env bash

# inside home
cd ~
ln -nfrs ./dotfiles/shared/bin .
ln -nfrs ./dotfiles/shared/.gitconfig .
# zsh startup files now live under shared/zsh/. .zshenv holds the base config
# (all shells); it replaces the former KTMR-managed ~/.zshenv (brew shellenv is
# now in the repo). .zshrc is interactive-only.
ln -nfrs ./dotfiles/shared/zsh/.zshenv .
ln -nfrs ./dotfiles/shared/zsh/.zprofile .
ln -nfrs ./dotfiles/shared/zsh/.zshrc .

# inside ~/.config
cd ~/.config
ln -nfrs ../dotfiles/shared/alacritty .
ln -nfrs ../dotfiles/shared/bat .
ln -nfrs ../dotfiles/shared/delta .
ln -nfrs ../dotfiles/shared/kitty .
ln -nfrs ../dotfiles/shared/nvim .
ln -nfrs ../dotfiles/shared/starship .
ln -nfrs ../dotfiles/shared/gitui .
ln -nfrs ../dotfiles/shared/omz .
ln -nfrs ../dotfiles/shared/yazi .
# yazi/theme.toml holds only the active flavor and is a gitignored runtime
# artifact (written by settheme). Seed it from the committed default on a fresh
# clone so yazi has a flavor before the first `settheme` run.
[ -f ../dotfiles/shared/yazi/theme.toml ] || \
  cp ../dotfiles/shared/yazi/theme.toml.default ../dotfiles/shared/yazi/theme.toml
ln -nfrs ../dotfiles/shared/mise .
ln -nfrs ../dotfiles/shared/fish .
