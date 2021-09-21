#!/usr/bin/env bash

echo -e '\033[1mThis script will change your current confiuration. Make sure to take a backup before proceeding.\033[0m'
echo -ne '\033[1mDo you want to continue? [y/N]: \033[0m'
read -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Operation aborted"
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

echo "Not implemented yet :)"
exit

# Get the absolute script path
# https://stackoverflow.com/a/4774063
# SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
SCRIPTPATH="$(cd "$(dirname "$0")" && pwd)"

_config_path=$HOME/.config
mkdir -p $_config_path

# TODO: do the rest of stuff