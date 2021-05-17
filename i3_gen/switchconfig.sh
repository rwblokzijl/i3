#!/bin/bash

cd $HOME/.config/i3/i3_gen

PROFILES="./presets"

USER_PICK=$(ls -p $PROFILES | grep -v / | rofi -show run -dmenu -config ~/.config/i3/rofi.conf)

if [[ -z $USER_PICK ]]; then
	echo "No user input"
	exit 1
fi

# update the new profile
if [[ $(ls $PROFILES | grep "$USER_PICK") ]]; then
	ln -sf "$PROFILES/$USER_PICK" ./.preset
else
	echo "Invalid input"
	exit 1
fi

# will still exit without changes if anything goes wrong in setting rofi

source ./generate.sh
