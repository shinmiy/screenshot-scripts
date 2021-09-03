#!/bin/bash

#############################################################
# mp4togif.sh
# ========================================
# $ ./mp4togif.sh video_to_convert.mp4
# ========================================
# ffmpeg入ってること前提
# $ brew install ffmpeg
# （参考）
# FFmpegで動画をGIFに変換
# https://qiita.com/wMETAw/items/fdb754022aec1da88e6e
# ffmpegで動画を綺麗なgifに変換するコツ
# https://life.craftz.dog/entry/generating-a-beautiful-gif-from-a-video-with-ffmpeg
#############################################################

if [ "$1" != "" ]; then
    echo "Converting $1"
else
    echo "Parameter 1 is empty"
    exit 0;
fi

ffmpeg -i $1 -vf "palettegen" -y $1_palette.png

filename=$(basename -- "$1")
extension="${filename##*.}"
name="${filename%.*}"

fps=15
aspect="-1:480"

# 横320pxで縦はアス比キープ
# ffmpeg -i $1 -i $1_palette.png -lavfi "fps=10,scale=320:-1:flags=lanczos [x]; [x][1:v] paletteuse=dither=bayer:bayer_scale=5:diff_mode=rectangle" -y $name.gif

# ffmpeg -i $1 -i $1_palette.png -lavfi "fps=30,scale=-1:320:flags=lanczos [x]; [x][1:v] paletteuse=dither=bayer:bayer_scale=5:diff_mode=rectangle" -y $name.gif

# 縦720pxで横はアス比キープ
ffmpeg -i $1 -i $1_palette.png -lavfi "fps=15,scale=-1:720:flags=lanczos [x]; [x][1:v] paletteuse=dither=bayer:bayer_scale=5:diff_mode=rectangle" -y $name.gif

# 横720pxで横はアス比キープ
# ffmpeg -i $1 -i $1_palette.png -lavfi "fps=15,scale=720:-1:flags=lanczos [x]; [x][1:v] paletteuse=dither=bayer:bayer_scale=5:diff_mode=rectangle" -y $name.gif

# 縦480pxで横はアス比キープ
# ffmpeg -i $1 -i $1_palette.png -lavfi "fps=10,scale=-1:480:flags=lanczos [x]; [x][1:v] paletteuse=dither=bayer:bayer_scale=5:diff_mode=rectangle" -y $name.gif
# ffmpeg -i $1 -i $1_palette.png -lavfi "fps=15,scale=-1:480:flags=lanczos [x]; [x][1:v] paletteuse=dither=bayer:bayer_scale=5:diff_mode=rectangle" -y $name.gif

# ffmpeg -i $1 -i $1_palette.png -lavfi "fps=${fps},scale=${aspect}:flags=lanczos [x]; [x][1:v] paletteuse=dither=bayer:bayer_scale=5:diff_mode=rectangle" -y $name.gif



rm $1_palette.png