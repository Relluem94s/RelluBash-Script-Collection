#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <database_name>"
    exit 1
fi

DB_NAME="$1"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M")
FILENAME="${DB_NAME}_${TIMESTAMP}.sql"

mysqldump -u root -p "$DB_NAME" > "$FILENAME"
