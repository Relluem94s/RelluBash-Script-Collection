#!/bin/bash

for i in *.mkv; 
do 
ffmpeg -i "$i" -c:v libvpx-vp9 -crf 30 -b:v 0 -b:a 128k -c:a libopus "${i%.*}.webm";
done
