#!/usr/bin/env bash


# Get the absolute script path
# https://stackoverflow.com/a/4774063
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P)"
SCRIPTPATH=$(echo $SCRIPTPATH | sed -e 's#/$##')

SCRIPTNAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

_confd_dir_name="conf.d"

_confd_path="$SCRIPTPATH/$_confd_dir_name"
_config_file="$SCRIPTPATH/config"

rm -f $_config_file && touch $_config_file

exe="$SCRIPTPATH/$SCRIPTNAME"
echo -e "# ================ Required Keybindings and Setup ================\n" >> $_config_file
echo "bindsym \$mod+Shift+F2 exec --no-startup-id $exe && i3-msg restart" >> $_config_file 
echo "bindsym \$mod+Shift+F3 exec --no-startup-id $exe && i3-msg reload" >> $_config_file 

for f in "$_confd_path"/*.conf;
do
    echo -e '\n' >> $_config_file
    filename=$(basename "$f")
    echo -e "# ================ $_confd_dir_name/$filename ================\n" >> $_config_file
    cat $f >> $_config_file;
done
