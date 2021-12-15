#!/bin/bash

###########################################################################################
#                                       Gource Generator                                  #
#                                      by Relluem94 2021                                  #
###########################################################################################
#                                                                                         #
#                                                                                         #
# Change 'pathToRepos' to one above your git location (/home/rellu/repos/)                #
# Change 'pathToExport' to your wanted export location (/home/rellu/Videos/)              #
#                                                                                         #
#                                                                                         #
###########################################################################################
#                                      VARIABLES TO EDIT                                  #
###########################################################################################
pathToRepos="/home/rellu/repos/";
pathToExport="/home/rellu/Videos/";
screenResolution="2560x1440";
###########################################################################################
#                                     DO NOT TOUCH THE CODE                               #
###########################################################################################
#
#
#

cd /;
cd $pathToRepos;

find . -type d -name .git -print -execdir git symbolic-ref --short HEAD \;

read folder;

cd $folder;

printf -v date '%(%Y-%m-%d)T\n' -1 


gource \
    -s .03 \
    -$screenResolution \
    -f \
    --auto-skip-seconds .1 \
    --multi-sampling \
    --stop-at-end \
    --key \
    --highlight-users \
    --date-format "%d/%m/%y" \
    --hide mouse,filenames,usernames \
    --file-idle-time 0 \
    --max-files 0  \
    --background-colour 000000 \
    --font-size 25 \
    --output-ppm-stream - \
    --output-framerate 30 \
    | ffmpeg -y -r 30 -f image2pipe -vcodec ppm -i - -b 65536K "$pathToExport$folder-$date.mp4"
