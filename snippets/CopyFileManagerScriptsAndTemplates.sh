#!/bin/bash

###########################################################################################
#                             CopyFileManagerScriptsAndTemplates                          #
#                                     by Relluem94 2023                                   #
###########################################################################################
#                                                                                         #
#                                                                                         #
# This Program will copy the defaults templates and scripts                               #
#                                                                                         #
###########################################################################################
#                                     DO NOT TOUCH THE CODE                               #
###########################################################################################
#
#
#
echo "Copy Files..."

if [ -d "filemanager" ]; then
    cp filemanager/scripts/* ~/.local/share/nautilus/scripts/
    cp filemanager/templates/* ~/Templates
else
    cp ../filemanager/scripts/* ~/.local/share/nautilus/scripts/
    cp ../filemanager/templates/* ~/Templates
fi
#
#
#
###########################################################################################
#                                           END OF CODE                                   #
###########################################################################################
