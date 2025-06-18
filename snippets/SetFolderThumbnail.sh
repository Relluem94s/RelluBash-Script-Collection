#!/bin/bash

# Search Images

DIR=$(pwd)
FIRST_IMAGE=$(find "$DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) | head -n 1)

# Get From Video if no Image Found

if [ -z "$FIRST_IMAGE" ]; then
    VIDEO=$(find "$DIR" -type f \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.webm" \) | head -n 1)
    if [ -n "$VIDEO" ]; then
        ffmpeg -y -i "$VIDEO" -ss 00:00:02 -vframes 1 "$DIR/preview.png" >/dev/null 2>&1
        FIRST_IMAGE="$DIR/preview.png"
    fi
fi

# Set Thumbnail

if [ -n "$FIRST_IMAGE" ]; then
    gio set "$DIR" metadata::custom-icon "file://$FIRST_IMAGE"
    mv "$DIR" "${DIR}_tmp" && mv "${DIR}_tmp" "$DIR"
else
    echo "ERROR: No Image Found"
fi
