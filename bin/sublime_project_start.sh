#!/usr/bin/env sh

project_file=$(find . -maxdepth 1 -type f -iname "*.sublime-project" | head -1)
if [[ $project_file != "" ]]
then
   echo "Using project file: $project_file"
   subl "$@" $project_file
else
    echo "No .sublime-project file found"
    exit 1
fi
