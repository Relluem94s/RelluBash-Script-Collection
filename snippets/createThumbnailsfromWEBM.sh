#!/bin/bash

for i in *.webm; 
do 
ffmpeg -i "$i" -vf "select=eq(n\,94)" -q:v 3  -vframes 1 "${i%.*}.png";
done
