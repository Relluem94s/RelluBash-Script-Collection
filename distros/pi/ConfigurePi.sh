#!/bin/bash

###########################################################################################
#                                        Configure Pi                                     #
#                                      by Relluem94 2024                                  #
###########################################################################################
#                                                                                         #
#                                                                                         #
#                                                                                         #
###########################################################################################
#                                     DO NOT TOUCH THE CODE                               #
###########################################################################################
#
#
#
version="v1.0";
SPACER="================================================================================"
#
#
#
###########################################################################################
#                                               Config                                    #
###########################################################################################

echo $SPACER 
echo " "
echo "Configure Pi $version"
echo " "
echo $SPACER 
echo " "
echo " "
echo "Enter Hostname:"
read hostname
echo "Setting Hostname to: $hostname"
hostnamectl set-hostname $hostname
echo " "
echo " "
echo " "
echo " "
###########################################################################################
#                                            Installs                                     #
###########################################################################################
echo $SPACER
echo " "
echo "Install"
echo " "
echo $SPACER
echo " "
echo " "
echo "Updating Pi"
sudo apt update
sudo apt upgrade -y
echo " "
echo "Installing Packages"

sudo apt install git tmux liferea ranger


echo "copy bash Config"
cp ../shared/config/.bashrc ~/.bashrc
echo " "
echo "tmux Config"
cp ../shared/config/.tmux.conf ~/.tmux.conf
echo " "
echo "cloning tmux pluginmanager"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
echo " "
echo "cloning tmux cpu plugin"
git clone https://github.com/tmux-plugins/tmux-cpu ~/.tmux/plugins/tmux-cpu

echo " "
echo " "
echo " "
echo " "
###########################################################################################
#                                            Finished                                     #
###########################################################################################
echo $SPACER
echo " "
echo "Finished Installation and Configuration!"
echo " "
echo $SPACER
echo " "
echo " "
