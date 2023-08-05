#!/usr/bin/env bash

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
mkdir free
for var in "$@"
do
    backgroundremover -i "$var" -o "free/edit_$var.png"
done

IFS=$SAVEIFS
