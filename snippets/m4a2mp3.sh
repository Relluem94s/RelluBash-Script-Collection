#!/bin/bash

if [ $# -lt 2 ]; then
        echo "Usage: $0 inputname outputname "
        exit
fi

inputname=$1
outputname=$2
shift 2

ffmpeg -v 5 -y -i "$inputname" -acodec libmp3lame -ac 2 -ab 192k "$outputname"


