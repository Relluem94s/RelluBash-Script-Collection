#!/bin/bash

###########################################################################################
#                                    Start DEV Environment                                #
#                                      by Relluem94 2023                                  #
###########################################################################################
#                                                                                         #
#                                                                                         #
# Change 'pathToRepos' to one above your git location (/home/rellu/repos/)                #
# Change 'pathToDevServer' to dev Server location (/home/rellu/repos/test-server"/)       #
# Change 'plugin' to your git location folder name (RelluEssentials)                      #
# Change 'bash_collection' to the folder name of the Scripts (RelluBash-Script-Collection)#
# Change 'spigot_jar' to the name/version of Spigot (spigot-1.20.1.jar)                   #
#                                                                                         #
#                                                                                         #
###########################################################################################
#                                      VARIABLES TO EDIT                                  #
###########################################################################################

pathToServer="/home/rellu/repos/test-server/plugins/";
rcon_password="password";
###########################################################################################
#                                     DO NOT TOUCH THE CODE                               #
###########################################################################################
#
#
#
version="v1.1";

ARTIFACT_ID=$1

if [ -z "$ARTIFACT_ID" ]; then
    echo "No artifact ID provided. Usage: $0 <ARTIFACT_ID>"
    exit 1
fi


# Überprüfen, ob die Datei existiert und dann löschen
jarFiles=$(find "$pathToServer" -name "${ARTIFACT_ID}*.jar")

# Überprüfen, ob Dateien gefunden wurden
if [ -n "$jarFiles" ]; then
    for jarFile in $jarFiles; do
        echo "Delete File: $jarFile"
        rm "$jarFile"
    done
else
    echo "File ${ARTIFACT_ID}*.jar not found in $pathToServer"
fi
cd ./target
fileToCopy=$(ls | grep -E "^${ARTIFACT_ID}.*\.jar$")

if [ -n "$fileToCopy" ]; then
    echo "Copying file: $fileToCopy to $pathToServer"
    cp "./$fileToCopy" "$pathToServer"
else
    echo "No File was found"
fi


echo "Connecting to Server"
mcrcon -p $rcon_password reload 
# for rcon mcrcon is needed and can be found here https://src.fedoraproject.org/rpms/mcrcon
#
#
#
###########################################################################################
#                                           END OF CODE                                   #
###########################################################################################
