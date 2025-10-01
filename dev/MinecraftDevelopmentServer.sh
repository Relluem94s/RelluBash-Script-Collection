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
pathToRepos="/home/rellu/repos/";
pathToDevServer="/home/rellu/repos/test-server";
plugin="RelluEssentials";
spigot_jar="spigot-1.21.9.jar";
docker_mysql="mysql";
docker_phpmyadmin="phpmyadmin";
###########################################################################################
#                                     DO NOT TOUCH THE CODE                               #
###########################################################################################
#
#
#
version="v1.0";


docker start $docker_mysql
docker start $docker_phpmyadmin
cd $pathToDevServer
java -jar $spigot_jar -nogui

#
#
#
###########################################################################################
#                                           END OF CODE                                   #
###########################################################################################
