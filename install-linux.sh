#!/usr/bin/env bash

echo -e '\033[1mImportant ==>\033[0m This script assumes that you have cloned this dotfiles repository as ~/dotfiles. If this is not the case, then this script will not work. Please abort\n'
echo -e '\033[1mThis script will change your current confiuration. Make sure to take a backup before proceeding.\033[0m'
echo -ne '\033[1mDo you want to continue? [y/N]: \033[0m'
read -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Operation aborted"
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

# TODO, uncomment this.
exit

./shared/_apply/install-omz.sh
./shared/_apply/link-dots.sh

./linux/_apply/link-dots.sh
./linux/_apply/fedora-install-packages.sh
./linux/_apply/mise-install-packages.sh
./linux/_apply/fedora-system-settings.sh

./linux/fonts/download-fonts.sh
./linux/gnome/gnome-keybinds.sh
./linux/gnome/gnome-settings.sh

./shared/vscode/setup-vscode.sh
