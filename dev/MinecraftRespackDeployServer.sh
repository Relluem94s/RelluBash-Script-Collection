#!/bin/bash

###########################################################################################
#                                     Respack Development                                 #
#                                      by Relluem94 2024                                  #
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

cd $pathToRepos
cd RelluSGA-Resource-Pack
./build.sh

# Umgebungsvariablen für SSH-Zugangsdaten
SSH_PASSWORD=$SERVER_PASSWORD_RELLUEM94_DE
SSH_HOST=$SERVER_HOST_RELLUEM94_DE
SSH_USER=$SERVER_USER_RELLUEM94_DE
SSH_PORT=$SERVER_PORT_RELLUEM94_DE

# Pfad zum Zielverzeichnis auf dem Server
REMOTE_PATH="${SSH_USER}@${SSH_HOST}:/var/www/html/relluem94.de/uploads/RelluSGA-Resource-Pack"

# Überprüfen, ob script.sh erfolgreich war
if [ $? -ne 0 ]; then
    echo "Fehler beim Ausführen von script.sh. Abbruch."
    exit 1
fi

# ZIP-Datei in ./target/ finden
ZIP_FILE=$(find ./target/ -maxdepth 1 -type f -name "*.zip" | head -n 1)

# Überprüfen, ob eine ZIP-Datei gefunden wurde
if [ -z "$ZIP_FILE" ]; then
    echo "Keine ZIP-Datei in ./target/ gefunden. Abbruch."
    exit 1
fi

# ZIP-Datei auf den Server kopieren mit sshpass
echo "Kopiere $ZIP_FILE nach $REMOTE_PATH..."
SSHPASS="$SSH_PASSWORD" sshpass -e scp -P "$SSH_PORT" "$ZIP_FILE" "$REMOTE_PATH"

# Überprüfen, ob der Kopiervorgang erfolgreich war
if [ $? -eq 0 ]; then
    echo "ZIP-Datei erfolgreich auf den Server kopiert."
else
    echo "Fehler beim Kopieren der ZIP-Datei auf den Server."
    exit 1
fi
