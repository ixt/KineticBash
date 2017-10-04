#!/bin/bash
convert -background black -pointsize 1500 -fill orangered label:"$2" -trim +repage -resize 700x700! -bordercolor black -border 100x100 "$1"
