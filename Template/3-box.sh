#!/bin/bash
OUTPUT=${1:-test.png}
WORD1=${2:-TEST}
WORD2=${3:-TEST}
WORD3=${4:-TEST}
COLOR1=${5:-orangered}
COLOR2=${6:-orangered}
COLOR3=${7:-orangered}
KERNING=${8:-0}
BACKGROUND=${BACKGROUND:-black}

convert -font "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf" -pointsize 1000 -kerning $KERNING\
    \( -background transparent -alpha set -virtual-pixel transparent -fill "$COLOR1" label:"$WORD1" -trim +repage -resize 700x700!  \
        +distort Affine '0,700 0,0   0,0 -304.5,-175  700,700 304.5,-175' \) \
    \( -background transparent -alpha set -virtual-pixel transparent -fill "$COLOR2" label:"$WORD2" -trim +repage -resize 700x700!  \
        +distort Affine '700,0 0,0   0,0 -304.5,-175  700,700 0,304.5' \) \
    \( -background transparent -alpha set -virtual-pixel transparent -fill "$COLOR3" label:"$WORD3" -trim +repage -resize 700x700!  \
        +distort Affine '  0,0 0,0   0,700 0,304.5    700,0 304.5,-175' \) \
    -background "$BACKGROUND" -layers merge -trim +repage -resize 700x700! \
    -bordercolor "$BACKGROUND" -compose over  -border 50x50 "$OUTPUT"

