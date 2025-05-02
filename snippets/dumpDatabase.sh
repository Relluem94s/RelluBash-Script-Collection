#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <database_name>"
    exit 1
fi

DB_NAME="$1"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M")
FILENAME="${DB_NAME}_${TIMESTAMP}.sql"

MYSQL_HOST="$SERVER_MYSQL_HOST_LOCALHOST"
MYSQL_USER="$SERVER_MYSQL_USER_LOCALHOST"
MYSQL_PASSWORD="$SERVER_MYSQL_PASSWORD_LOCALHOST"



if [ -z "$MYSQL_HOST" ] || [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ]; then
    echo "Error: One or more required variables (MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD) not set in .secrets"
    exit 1
fi

# Creating Temp Config
TEMP_CNF=$(mktemp)
cat > "$TEMP_CNF" <<EOL
[client]
host=$MYSQL_HOST
user=$MYSQL_USER
password=$MYSQL_PASSWORD
EOL

chmod 600 "$TEMP_CNF"


# Starting Dump
mysqldump --defaults-extra-file="$TEMP_CNF" "$DB_NAME" > "$FILENAME"


if [ $? -eq 0 ]; then
    echo "Backup successfully created: $FILENAME"
else
    echo "Error creating backup"
    rm -f "$TEMP_CNF"
    exit 1
fi

rm -f "$TEMP_CNF"
