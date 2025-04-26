#!/bin/bash

###########################################################################################
#                                     Youtube Downloader                                  #
#                                   by Relluem94 2021 -2022                               #
###########################################################################################
#                                                                                         #
# Requires youtube-dl to run!                                                             #   
#                                                                                         #
###########################################################################################
#                                     DO NOT TOUCH THE CODE                               #
###########################################################################################
#
#
#
cmd="yt-dlp";
line="\e[90m======================================================";
line_small="\e[37m------------------------------------------------------";



echo -e "\e[97m";
echo -e $line_small;
echo -e "\e[37mYoutube Downloader \e[94mv1.2";
echo -e "";
echo -e "Check here for Updates: https://github.com/Relluem94s/RelluBash-Script-Collection";
echo -e $line_small;
echo -e "";

echo -e "\e[93m[LINK]\e[97m Enter Link to the Youtube Video you want to download:"
read link
echo -e "";
echo -e '\e[1;34m[OPTION]\e[97m Download Video or Audio Only?'
options=("Audio" "Video")
select opt in "${options[@]}"
do
    case $opt in
        "Audio")
            cmd="$cmd --extract-audio --audio-format mp3"; 
            break
            ;;
        "Video")
            #Skipping
            break
            ;;
        "exit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

echo -e "";
echo -e $line;
cmd="$cmd $link";
$cmd;
echo -e $line;
echo -en "\e[0m"
#
#
#
###########################################################################################
#                                           END OF CODE                                   #
###########################################################################################
