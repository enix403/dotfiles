# inside home
cd ~
ln -nfrs ./dotfiles/shared/bin .
ln -nfrs ./dotfiles/shared/.gitconfig .
ln -nfrs ./dotfiles/shared/.zprofile .
ln -nfrs ./dotfiles/shared/.zshrc .

# inside ~/.config
cd ~/.config
ln -nfrs ../dotfiles/shared/alacritty .
ln -nfrs ../dotfiles/shared/bat .
ln -nfrs ../dotfiles/shared/delta .
ln -nfrs ../dotfiles/shared/kitty .
ln -nfrs ../dotfiles/shared/nvim .
ln -nfrs ../dotfiles/shared/starship .
ln -nfrs ../dotfiles/shared/omz .
ln -nfrs ../dotfiles/shared/yazi .
ln -nfrs ../dotfiles/shared/mise .