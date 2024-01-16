#!/usr/bin/env bash

arr=()
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

for var in "$@"
do
    path=$(readlink -f $var)
    arr+=($path)
done

# Check if the client is a native app
if [ $(command -v shred) ]; then
    shred "${arr[@]}" -n 4 -u -v -f 
else
    echo "Error"
fi

IFS=$SAVEIFS
