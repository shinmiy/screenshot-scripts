#!/bin/bash
DIRECTORY="/sdcard/DCIM/Camera/"

while getopts g OPT; do
  case $OPT in
  g)
    strip_gps=1
    ;;
  esac
done

for fullpath in `adb shell exec ls ${DIRECTORY}*.{jpg,JPG,png} 2>/dev/null|peco`
do
  filename=$(basename -- "$fullpath")
  extension="${filename##*.}"
  name="${filename%.*}"

  adb pull $fullpath .

  if [ $strip_gps ]; then
    echo "exiftool -geotag= $filename"
    exiftool -geotag= $filename
  fi

  should_open=1
done

if [ $should_open ]; then
  open .
fi