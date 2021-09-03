#!/bin/bash

size=1440

usage_exit() {
    echo "Usage: $0 [-s size] file" >&2
    exit 1
}

##################################
can_run=true
if [ ! -f "$(which convert)" ]; then
  echo "error: Could not find convert" >&2
  echo "Install via homebrew: brew install imagemagick" >&2
  can_run=false
fi

if [ ! -f "$(which jpegoptim)" ]; then
  echo "error: Could not find jpegoptim" >&2
  echo "Install via homebrew: brew install jpegoptim" >&2
  can_run=false
fi

if [ ! can_run ];then
  usage_exit
fi

##################################

##################################
if [ $# -eq 0 ];then
  usage_exit
fi

while getopts s:h OPT; do
  case $OPT in
  s)
    re='^[0-9]+$'
    if ! [[ $OPTARG =~ $re ]] ; then
      echo "error: Not a number" >&2; usage_exit
    fi
    size=$OPTARG
    ;;
  h) usage_exit
    ;;
  esac
done

# getopts分の引数値移動
shift $(($OPTIND - 1))
##################################

#File checks
if [ "$1" == "" ]; then
    echo "error: No file provided" >&2; usage_exit
fi
if [ ! -f "$1" ]; then
  echo "error: Could not find $1." >&2; usage_exit
fi
if file "$1" | grep -vqE 'image|bitmap'; then
  echo "error: $1 is not an image file." >&2; usage_exit
fi

filename=$(basename -- "$1")
extension="${filename##*.}"
name="${filename%.*}"

new_filename=${name// /-}_small.$extension

echo "converting $filename to $new_filename"

convert -resize "${size}>" "$1" $new_filename
# jpegoptim -qm80 $new_filename
pngquant $new_filename

rm -i "$1"

open -R $new_filename