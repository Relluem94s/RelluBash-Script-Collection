#!/usr/bin/env bash

arr=()
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")



# Check if the client is a native app
if [ $(command -v convert) ]; then
    for var in "$@"
    do
        convert -resize 1024 "$var" "th_$var"
    done
else
    echo "Error"
fi

IFS=$SAVEIFS

