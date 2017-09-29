#!/bin/bash
FILE=$1
HEADEREND=$(sed -n "/##/=" "$FILE")
WORKINGDIR=$(dirname $0)
DEBUG=1
FPS=25

cd $WORKINGDIR

# if [ ! $QUIET ]; then echo "[*] Working Environment Created"; fi
# # Create working file
# touch .temp
# echo "" > .temp
# mkdir .frames
# sudo mount -t tmpfs -o size=4096m tmpfs .frames/
# 
# 
# # Clean Off Header 
# 
# if [ ! $QUIET ]; then echo "[*] Cleaning Header"; fi
# tail +$(( HEADEREND + 3 )) "$FILE" >> .temp
# # Clean Gunk
# sed -i -e "/-->/d" \
#     -e "s/<c>//g" \
#     -e "s/<\/c>//g" \
#     -e "s/<c.color[0-F]*[^>]>//g" \
#     -e "s/[[:space:]]//g" \
#     -e "s/>/>\n/g" \
#     -e "/^$/d" \
#     .temp
# 
# if [ ! $QUIET ]; then echo "[*] Filling in the blanks"; fi
# # Not the best solution to missing stamps 
# # but its the best I can think rn 
# # just take the previous stamp and add it
# while read LINETO; do
#     LINEFROM=$(( LINETO - 1 ))
#     until grep -q -E ">" <(sed -e "$LINEFROM"'!d' .temp); do
#         (( LINEFROM -= 1 ))
#     done
#     STAMP=$(sed -e "$LINEFROM"'!d' .temp | cut -d"<" -f2 )
#     sed -i -e "$LINETO"'s/$/<'"$STAMP"'/' .temp
# done < <(sed -n "/[^>]$/=" .temp)  
# 
# sed -i -e "s/</|/g" -e "s/>//g" .temp
# 
# # Time stamp to milliseconds 
# 
# if [ ! $QUIET ]; then echo "[*] Changing Timestamps to milliseconds (this may take a while)"; fi
# 
# while read LINE; do
#     STAMP=$(sed -e "$LINE"'!d' -e "s/:/./g" .temp | cut -d"|" -f2)
#     IFS=. read -a STAMP_EL <<< "$STAMP"
#     MS=$(bc -l <<< "(((((${STAMP_EL[0]} * 60) + ${STAMP_EL[1]}) * 60 ) + ${STAMP_EL[2]}) * 1000 ) + ${STAMP_EL[3]}")
#     sed -i "$LINE"'s/|.*/|'"$MS"'/' .temp
# done < <(sed -n "/|/=" .temp)
# 
# if [ ! $QUIET ]; then echo "[*] Making Frames"; fi
# ffmpeg -framerate 1 -loop 1 -i <(convert -background black -fill orangered -size 500x500 label:"test-message" jpg:-) -t 1 -r $FPS ".frames/start.mp4"

COUNT=0
WORDBANK=()
MILLISFRAMES=$(bc -l <<< "scale=0;(1000 / $FPS)")
while read LINE; do
    RAW=$(echo $LINE | sed -e "s/|/./")
    IFS=.  read -a line <<< "$RAW"
    NEXTFRAME=$(bc -l <<< "($COUNT + 1 ) * $MILLISFRAMES")
    if [ "${line[1]}" -lt "$NEXTFRAME" ]; then 
        WORDBANK+=("${line[0]}")
    fi
    if [ "${line[1]}" -ge "$NEXTFRAME" ]; then 
        until [ "${line[1]}" -le "$NEXTFRAME" ]; do 
            #echo "$COUNT: ${WORDBANK[@]}"
            let "COUNT++"
            # if [ ${#WORDBANK[@]} -eq "0" ]; then 
            #     ffmpeg -framerate 1 -loop 1 -i \
            #         <(convert -background black -fill orangered -size 500x500 -gravity center label:"starting" jpg:-) \
            #         -t 1 -r $FPS ".frames/newframe.mp4" -y
            # else
            #     ffmpeg -framerate 1 -loop 1 -i \
            #         <(convert -background black -fill orangered -size 500x500 -gravity center label:"${WORDBANK[@]}" jpg:-) \
            #         -t 1 -r $FPS ".frames/newframe.mp4" -y
            # fi
            # ffmpeg -f concat -safe 0 -i input.txt -c copy ".frames/merged.mp4" -y
            # mv ".frames/merged.mp4" ".frames/start.mp4"
        done
        WORDBANK=()
        WORDBANK+=("${line[0]}")
    fi
done < .temp

# Clean up
if [ ! $DEBUG ]; then rm .temp .frames/* .frames -d; fi
