#!/bin/bash

sudo dnf update --refresh -y
sudo dnf upgrade --refresh -y

sudo dnf install wine winetricks

wget https://support.image-line.com/redirect/flstudio20_win_installer -P /tmp/fl_studio

cd /tmp/fl_studio

files=(./*.exe)
echo "${files[0]}"

wine ${files[0]}

rm -rf /tmp/fl_studio
