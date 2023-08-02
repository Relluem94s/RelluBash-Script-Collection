#!/usr/bin/env bash

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
mkdir free
for var in "$@"
do
    if [ -f "$file" ]; then 
        backgroundremover -i "$file" -o "free/edit_$file.png"
    fi 
done

IFS=$SAVEIFS
