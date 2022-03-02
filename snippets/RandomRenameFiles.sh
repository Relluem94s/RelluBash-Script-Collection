#!/bin/bash

if [ -n "$1" ]; then
	echo "Change Directory to $1"
	cd "$1"
	
	if [ -n "$2" ]; then
		for f in *.$2; 
			do # mv "$f" $RANDOM-"$f"; 
			echo "Moving $f to" $RANDOM-"$f";
		done
	else
	 	echo "Parameter two (Extension) is missing"
	fi
else 
	echo "Parameter one (Directory) is missing"
fi
