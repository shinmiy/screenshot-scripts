# !/bin/bash

# -r shrink height/width by 50%

# output file name prefix
PREFIX="screenrec"

while getopts d:t:r OPT; do
  case $OPT in
  r)
    resize=1
    ;;
  esac
done

# Select if multiple devices are connected
devices=($(adb devices | sed -n '1d;p' | sed '$ d' | cut -f1))
if [ ${#devices[@]} -gt 1 ]; then
  if [ $deviceindex ]; then
    index=$deviceindex
  else
    for ((i = 0; i < ${#devices[@]}; i++)); do
      name=$(adb -s ${devices[i]} shell getprop ro.product.model)
      echo "[$i] $name"
    done
    read -p "select device[0]:" index
  fi
  device=${devices[${index:-0}]}
else
  device=${devices[0]}
fi

if [ ! $device ]; then
  echo "No valid device"
  exit 1
fi

# Gather info
version=$(adb -s $device shell getprop ro.build.version.sdk | tr -d '\r')
name=$(adb -s $device shell getprop ro.product.model | sed 's/[\/_ ]/-/g' | tr -d '\r')
curdate=$(date +"%y%m%d-%H%M%S")

# Take screenshot
filename="${PREFIX}_${name}_${curdate}.mp4"

# echo "Recording... $filename"
echo "adb -s $device shell screenrecord /sdcard/$filename"
# adb -s $device shell screenrecord /sdcard/$filename
echo "adb -s $device pull /sdcard/$filename"
# adb -s $device pull /sdcard/$filename
echo "adb -s $device shell rm /sdcard/$filename"
# adb -s $device shell rm /sdcard/$filename

if [ $resize ]; then
  echo "./scale_video.sh $filename"
  ./scale_video.sh $filename
fi
