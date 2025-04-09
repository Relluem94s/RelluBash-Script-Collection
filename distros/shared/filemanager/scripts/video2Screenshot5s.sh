#!/usr/bin/env bash

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

for filepath in "$@"; do
    mimetype=$(file --mime-type -b "$filepath")
    filename=$(basename "$filepath")
    extension="${filename##*.}"
    filename_no_ext="${filename%.*}"
    dir=$(dirname "$filepath")

    case "$mimetype" in
        video/*)
            if command -v ffmpeg > /dev/null; then
                ffmpeg -i "$filepath" -vf fps=1/5 "$dir/${filename_no_ext}_img_%03d.jpg"
            else
                echo "ffmpeg not found"
            fi
            ;;
        *)
            echo "No Video File: $filepath"
            ;;
    esac
done

IFS=$SAVEIFS

