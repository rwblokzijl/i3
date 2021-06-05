#!/bin/bash

# This script locks the screen showing the screencontents to be blurred
# This works as follows
# - Take screenshot
# - blur the image
# - add lock icon to the middle
# - start i3lock with the image as background

# Note that on large screens that the image processing is expensive (time wise)
# This is why the image is scaled down, then the operations are applied, then
# the image is scaled up again (as i3lock doesnt allow scaling of images)

ICON=$HOME/.config/i3/scripts/icon.png
TMPBG=/tmp/screen.png

# Take screenshot
rm $TMPBG
scrot $TMPBG

# scale down and up to blur
# convert $TMPBG -scale 10% $TMPBG
# convert $TMPBG -scale 1000% $TMPBG

# add icons

# SIZES=$(xrandr |              grep -oP '\d+x\d+\+\d+\+\d+' | sed 's/x/ /g; s/+/ /g')
SIZES=$(xrandr | grep primary | grep -oP '\d+x\d+\+\d+\+\d+' | sed 's/x/ /g; s/+/ /g')
ICON_SIZE=($(identify -format '%w %h' $ICON))

while read -r line
do
	W_H_X_Y=($line)
	let WIDTH=${W_H_X_Y[0]}/2+${W_H_X_Y[2]}-${ICON_SIZE[0]}/2
	let HEIGHT=${W_H_X_Y[1]}/2+${W_H_X_Y[3]}-${ICON_SIZE[1]}/2
	convert $TMPBG $ICON -geometry +$WIDTH+$HEIGHT -composite -matte $TMPBG #add an icon
done <<< "$SIZES"

i3lock -i $TMPBG
