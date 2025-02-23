#!/usr/bin/env bash

# Available Styles
#
# blurry	blurry_full		kde_simplemenu		kde_krunner		launchpad
# gnome_do	slingshot		appdrawer			appdrawer_alt	appfolder
# column	row				row_center			screen			row_dock		row_dropdown

# theme="row"
# theme="row_center"
theme="kde_simplemenu"

dir="$HOME/.config/rofi/launchers/misc"
rofi -no-lazy-grab -modi "drun,run,window" -show drun -theme $dir/"$theme" -font "Fira Code 18"
