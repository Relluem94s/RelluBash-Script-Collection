#!/bin/bash

sudo dnf update --refresh -y
sudo dnf upgrade --refresh -y

sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://dl.winehq.org/wine-builds/fedora/35/winehq.repo

sudo dnf -y install winehq-stable

# sudo dnf install winetricks

wget https://demodownload.image-line.com/flstudio/flstudio_win64_20.9.2.2963.exe -P /tmp/fl_studio

cd /tmp/fl_studio

files=(./*.exe)
echo "${files[0]}"

wine ${files[0]}

rm -rf /tmp/fl_studio


