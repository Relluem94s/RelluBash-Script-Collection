#!/bin/bash

sudo dnf update --refresh -y
sudo dnf upgrade --refresh -y

sudo dnf install wine winetricks

wget https://demodownload.image-line.com/flstudio/flstudio_win64_20.9.2.2963.exe -P /tmp/fl_studio

cd /tmp/fl_studio

files=(./*.exe)
echo "${files[0]}"

wine ${files[0]}

rm -rf /tmp/fl_studio
