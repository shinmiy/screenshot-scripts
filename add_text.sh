#!/bin/bash
# --------------------------------
# 動画にいい感じのテロップをつけるやつ
# 参考：https://stackoverflow.com/a/17624103
# --------------------------------

FONT_FILE="/Users/shintaro.miyabe/Library/Fonts/SourceHanCodeJP.ttc"

fullpath=$1
text=$2

filename=$(basename -- "$fullpath")
extension="${filename##*.}"
name="${filename%.*}"

ffmpeg -i $fullpath -vf drawtext="${FONT_FILE}: \
text='${text}': fontcolor=white: fontsize=24: box=1: boxcolor=black@0.5: \
boxborderw=5: x=8: y=8" -codec:a copy ${name}_withtext.${extension}
