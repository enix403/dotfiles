#!/usr/bin/env sh

search_path="."

if [[ "$1" != "" ]]
then
    search_path="$1"
fi

project_file=$(find "$search_path" -maxdepth 2 -type f -iname "*.sublime-project" | head -1)
if [[ $project_file != "" ]]
then
   echo "Using project file: $project_file"
   subl "$@" $project_file
else
    echo "No .sublime-project file found"
    exit 1
fi
