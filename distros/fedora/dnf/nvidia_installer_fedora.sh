#!/bin/bash

###########################################################################################
#                                     NVIDIA INSTALLER                                    #
#                                     by Relluem94 2023                                   #
###########################################################################################
#                                                                                         #
#                                                                                         #
# This will install NVIDIA Drivers for Fedora                                             #
#                                                                                         #
###########################################################################################
#                                     DO NOT TOUCH THE CODE                               #
###########################################################################################
#
#
#

sudo dnf upgrade --refresh -y

sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf update --refresh

sudo dnf install akmod-nvidia -y
sudo dnf install xorg-x11-drv-nvidia-cuda -y


reboot

#
#
#
###########################################################################################
#                                           END OF CODE                                   #
###########################################################################################
