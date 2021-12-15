#!/bin/bash

###########################################################################################
#                                         Auto Git Pull                                   #
#                                      by Relluem94 2021                                  #
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
line="\e[90m============================================================";
line_small="\e[37m------------------------------------------------------------";
prefix_git="\e[36m[GIT]     ";

echo -e "\e[97m";
echo -e $line_small;
echo -e "\e[37mAuto Git Pull \e[94m$version";
echo -e $line_small;
echo -e "\e[37mFetch and Pulls every Repos in the given Path. ";
echo -e "\e[37mExample:\e[36m ./AutoGitPull.sh";
echo -e "";
echo -e "";
echo -e "Check here for Updates: https://github.com/Relluem94s/RelluBash-Script-Collection";
echo -e $line_small;
echo -e "";
echo

IFS=$'\n'

for REPO in `ls "$pathToRepos/"`
do
  if [ -d "$pathToRepos/$REPO" ]
  then
    if [ -d "$pathToRepos/$REPO/.git" ]
    then
      cd "$pathToRepos/$REPO"
      echo -e "$prefix_git\e[37m$REPO \e[91m>> \e[37mFetching"
      git fetch
      echo -e "$prefix_git\e[37m$REPO \e[92m<< \e[37mPulling"
      echo
      git pull
      echo
      echo
    fi
  fi
done
