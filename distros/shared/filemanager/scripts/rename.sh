#!/usr/bin/env bash

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

for var in "$@"
do
    mv $var "$RANDOM-$var"; 
done

IFS=$SAVEIFS
