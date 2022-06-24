#!/usr/bin/bash

input="$*"
length="${#input}"

charindex=0
newstring=""

while [ $charindex -lt $length ]
do
    char="${input:$charindex:1}"
    
    # conversion occurs here
    doit=$(( $RANDOM % 10 ))       # random virtual coin flip
    if [ -z "$(echo "$char" | sed -E 's/[[:lower:]]//')" ]
    then
      # lowercase. 50% chance we'll change it
      if [ $doit -lt 5 ] ; then
        char="$(echo $char | tr '[[:lower:]]' '[[:upper:]]')"
      fi
    elif [ -z "$(echo "$char" | sed -E 's/[[:upper:]]//')" ]
    then
      # uppercase. 30% chance we'll change it
      if [ $doit -lt 3 ] ; then
        char="$(echo $char | tr '[[:upper:]]' '[[:lower:]]')"
      fi
    fi

    newstring="${newstring}$char"
    charindex=$(( $charindex + 1 ))
done

echo $newstring