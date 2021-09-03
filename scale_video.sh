#!/bin/bash
SCALE="720"

fullpath=$1

if [ $fullpath ];then
echo $fullpath
else
echo No file provided
exit 1
fi

filename=$(basename -- "$fullpath")
extension="${filename##*.}"
name="${filename%.*}"

ffmpeg -i $fullpath -vf scale=-2:${SCALE} ${name}_${SCALE}p.mp4
# ffmpeg -i $fullpath -vf scale=-2:${SCALE} -ab 64k ${name}_${SCALE}p.mp4

rm -i $fullpath

open .


# ffmpeg -i $fullpath -vf scale=-2:${SCALE} -an ${name}_${SCALE}p.${extension}
# ffmpeg -i $fullpath -vf scale=-2:${SCALE} -an ${name}_${SCALE}p.mp4
