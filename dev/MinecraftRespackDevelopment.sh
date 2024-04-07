#!/bin/bash

###########################################################################################
#                                     Respack Development                                 #
#                                      by Relluem94 2024                                  #
###########################################################################################
#                                                                                         #
#                                                                                         #
# Change 'pathToRepos' to one above your git location (/home/rellu/repos/)                #
# Change 'pathToMinecraft' to dev Server location (/home/rellu/repos/test-server"/)       #
#                                                                                         #
#                                                                                         #
###########################################################################################
#                                      VARIABLES TO EDIT                                  #
###########################################################################################
pathToRepos="/home/rellu/repos/";
pathToMinecraft="/home/rellu/.var/app/com.mojang.Minecraft/.minecraft/resourcepacks/";

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

echo "Copying Zip in Resource Pack Folder"
cp ./target/*.zip $pathToMinecraft

#
#
#
###########################################################################################
#                                           END OF CODE                                   #
###########################################################################################
