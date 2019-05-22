#!/bin/bash
ICON=$HOME/.config/i3/icon.png
TMPBG=/tmp/screen.png

#take a screenshot
scrot $TMPBG

#blur
convert $TMPBG -scale 10% -sample 1000% $TMPBG
#convert -modulate 100,0 -modulate 50 -blur 0x10 -auto-gamma $TMPBG $TMPBG
#convert $TMPBG $ICON -gravity center -composite -matte $TMPBG

#lock using the blurred pic
i3lock -u -i $TMPBG
