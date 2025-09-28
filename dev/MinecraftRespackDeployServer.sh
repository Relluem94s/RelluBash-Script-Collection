#!/bin/bash

###########################################################################################
#                                    Respack Server Deploy                                #
#                                      by Relluem94 2025                                  #
###########################################################################################
#                                                                                         #
#                                                                                         #
# Change 'pathToRepos' to one above your git location (/home/rellu/repos/)                #

#                                                                                         #
#                                                                                         #
###########################################################################################
#                                      VARIABLES TO EDIT                                  #
###########################################################################################
pathToRepos="/home/rellu/repos/";

###########################################################################################
#                                     DO NOT TOUCH THE CODE                               #
###########################################################################################
#
#
#
version="v1.0";

SSH_PASSWORD=$SERVER_PASSWORD_RELLUEM94_DE
SSH_HOST=$SERVER_HOST_RELLUEM94_DE
SSH_USER=$SERVER_USER_RELLUEM94_DE
SSH_PORT=$SERVER_PORT_RELLUEM94_DE
RESPACK_FOLDER=$SERVER_MINECRAFT_RESPACK_FOLDER_RELLUEM94_DE


echo "Ressource Pack Deployment Tool $version"
echo ""

cd $pathToRepos || exit
cd RelluSGA-Resource-Pack || exit

./build.sh

if [ $? -ne 0 ]; then
    echo "Error building Respack"
    exit 1
fi


REMOTE_PATH="${SSH_USER}@${SSH_HOST}:${RESPACK_FOLDER}"

ZIP_FILE=$(find ./target/ -maxdepth 1 -type f -name "*.zip" | head -n 1)
INDEX_FILE="./index/index.php"



if [ -z "$ZIP_FILE" ]; then
    echo "No zip-file in ./target/ found."
    exit 1
fi

if [ ! -f "$INDEX_FILE" ]; then
    echo "No index.php in ./index/ found."
    exit 1
fi

echo "Copy $ZIP_FILE to $REMOTE_PATH..."
SSHPASS="$SSH_PASSWORD" sshpass -e scp -P "$SSH_PORT" "$ZIP_FILE" "$REMOTE_PATH"

if [ $? -ne 0 ]; then
    echo "Error copying the ZIP file to the server."
    exit 1
fi

echo "Copy $INDEX_FILE to $REMOTE_PATH..."
SSHPASS="$SSH_PASSWORD" sshpass -e scp -P "$SSH_PORT" "$INDEX_FILE" "$REMOTE_PATH"

if [ $? -ne 0 ]; then
    echo "Error copying the index file to the server."
    exit 1
else
    echo "ZIP file and index.php successfully copied to the server."
fi

