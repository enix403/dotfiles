#!/usr/bin/env bash


echo "This script will overwrite your current confiuration. Make sure to take a backup before proceeding."
read -p "Do you want to continue? [Y/n]: " -r
echo # move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo
    echo "Operation aborted"
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

exit

# Get the absolute script path
# https://stackoverflow.com/a/4774063
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

_config_path=$HOME/.config
mkdir -p $_config_path

# TODO: do the rest of stuff