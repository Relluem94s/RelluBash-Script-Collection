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

if [ "$1" = "fedora" ]; then
    cp ../shared/filemanager/scripts/* ~/.local/share/nautilus/scripts/
    cp ../shared/filemanager/scripts/* ~/.local/share/nemo/scripts/
    cp ../shared/filemanager/templates/* ~/Templates
else
    cp ../distros/shared/filemanager/scripts/* ~/.local/share/nautilus/scripts/
    cp ../distros/shared/filemanager/scripts/* ~/.local/share/nemo/scripts/
    cp ../distros/shared/filemanager/templates/* ~/Templates
fi
#
#
#
###########################################################################################
#                                           END OF CODE                                   #
###########################################################################################
