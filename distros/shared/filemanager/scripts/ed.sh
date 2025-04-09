#!/bin/bash

# Check if xclip is installed
if ! command -v xclip &> /dev/null; then
    notify-send "Error" "Please install xclip to use this script"
    exit 1
fi

# Get URL from clipboard
URL=$(xclip -selection clipboard -o)

# Check if URL is empty
if [ -z "$URL" ]; then
    notify-send "Error" "No URL found in clipboard"
    exit 1
fi

# Validate URL format (basic check)
if [[ ! "$URL" =~ ^https?:// ]]; then
    notify-send "Warning" "Clipboard content doesn't look like a valid URL"
fi

# Call your python script
~/repos/x_old/ed/dump.py -u "$URL"
