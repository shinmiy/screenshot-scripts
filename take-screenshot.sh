# !/bin/bash

#############################################################
# take-screenshot.sh
# ========================================
# $ ./take-screenshot.sh
# [0] Pixel 3a
# [1] ASUS_Z01KD
# select device[0]:1
# Taking screenshot... capture_ASUS-Z01KD_190829-170756.png
# ========================================
# -d select device
# -t add tag to end of filename
# -r shrink height/width by 50%
#############################################################

# output file name prefix
PREFIX="capture"

while getopts d:t:r OPT; do
  case $OPT in
  d)
    deviceindex=$OPTARG
    ;;
  t)
    tag=$(echo $OPTARG | sed 's/[\/_ ]/-/g')
    ;;
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
if [ $tag ]; then
  filename="${PREFIX}_${name}_${curdate}_${tag}.png"
else
  filename="${PREFIX}_${name}_${curdate}.png"
fi

echo "Taking screenshot... $filename"
if [ $version -ge 20 ]; then
  echo "adb -s $device exec-out screencap -p > $filename"
  adb -s $device exec-out screencap -p >$filename
else
  adb -s $device shell screencap -p /sdcard/$filename
  adb -s $device pull /sdcard/$filename
  adb -s $device shell rm /sdcard/$filename
fi

# Use Imagemagick to resize to 50% if necessary
# https://imagemagick.biz/archives/93
# $ brew install imagemagick
if [ $resize ]; then
  # convert $filename -resize 50% $filename
  echo "convert $filename -adaptive-resize 50% $filename"
  convert $filename -adaptive-resize 50% $filename
fi

# Compress png with pngquant
# https://pngquant.org
# https://qiita.com/thanks2music/items/309700a411652c00672a
# $ brew install pngquant
echo "pngquant --ext .png --force $filename"
pngquant --ext .png --force $filename

open -R $filename