#!/bin/bash

PYTHON_SCRIPT=$PYHTON_DOWNLOADER_SCRIPT
URL=$PYTHON_DOWNLOADER_URL
URL_PARAMETER=""
SUFFIX=""
REUSE=false

# Arguments parse

while [[ $# -gt 0 ]]; do
    case "$1" in
        -s|--same)
            REUSE=true
            ;;
        *)
            if [ -z "$URL_PARAMETER" ]; then
                URL_PARAMETER="$1"
            elif [ -z "$SUFFIX" ]; then
                SUFFIX="$1"
            fi
            ;;
    esac
    shift
done


# Check URL

if [ -z "$URL_PARAMETER" ]; then
    echo "ERROR: URL_PARAMETER missing"
    exit 1
fi

# Create Folder
max=0
last_name=""
for dir in */; do
    name="${dir%/}"
    if [[ "$name" =~ ^([0-9]{4})(_.+)?$ ]]; then
        num=${BASH_REMATCH[1]}
        if ((10#$num > max)); then
            max=$((10#$num))
            last_name="$name"
        fi
    fi
done

if [ "$REUSE" = true ]; then
    if [ -n "$SUFFIX" ]; then
        dirname="${max}_${SUFFIX}"
    else
        dirname="$last_name"
    fi
else
    next=$((max + 1))
    printf -v base "%04d" "$next"
    if [ -n "$SUFFIX" ]; then
        dirname="${base}_${SUFFIX}"
    else
        dirname="$base"
    fi
    mkdir "$dirname" || { echo "ERROR: mkdir could not create Folder"; exit 1; }
fi


cd "$dirname" || { echo "ERROR: cd could not change to Folder"; exit 1; }

echo "Using Folder: $dirname "

# Download

MAX_ATTEMPTS=5
SLEEP_INTERVAL=5
attempt=1

while [ $attempt -le $MAX_ATTEMPTS ]; do
  python3 "$PYTHON_SCRIPT" -u "$URL$URL_PARAMETER" && find downloads -type f -exec cp {} . \; && rm -rf downloads
  
  if [ $? -eq 0 ]; then
    break
  else
      echo ""
      echo "############################"
      echo "Retry: $attempt / $MAX_ATTEMPTS..."
      echo "############################"
      echo ""
    sleep $SLEEP_INTERVAL
    ((attempt++))
  fi
done

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

# Go Back to main Folder

cd ..
