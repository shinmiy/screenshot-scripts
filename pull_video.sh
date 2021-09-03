#!/bin/bash
DIRECTORY="/sdcard/DCIM/Camera/"
SCALE="720"

for fullpath in `adb shell exec ls ${DIRECTORY}*.mp4|peco`
do
filename=$(basename -- "$fullpath")
extension="${filename##*.}"
name="${filename%.*}"
adb pull $fullpath .
# ffmpeg -i $filename -vf scale=-1:${SCALE} ${name}_${SCALE}p.${extension}
ffmpeg -i $filename -vf scale=-1:${SCALE} -an ${name}_${SCALE}p.${extension}
# rm -i $filename
done

open .
