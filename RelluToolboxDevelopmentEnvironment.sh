#!/bin/bash

###########################################################################################
#                                    Start DEV Environment                                #
#                                      by Relluem94 2023                                  #
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

tmux new-session -d -s bash-session 'bash';
tmux select-pane -T "RelluToolbox - RelluBash-Script-Collection $version" 
tmux send "cd shared" ENTER;
tmux send "npm test" ENTER;

tmux split-window -h;
tmux select-pane -T 'git'

tmux a;  
#
#
#
###########################################################################################
#                                           END OF CODE                                   #
###########################################################################################
