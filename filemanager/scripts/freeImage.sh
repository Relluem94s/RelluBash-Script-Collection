#!/usr/bin/env bash

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
mkdir free
for var in "$@"
do
    backgroundremover -i "$file" -o "free/edit_$file.png"
done

IFS=$SAVEIFS
