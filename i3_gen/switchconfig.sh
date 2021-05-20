#!/bin/bash

cd $HOME/.config/i3/i3_gen

PRESETS="./presets"
ENVIRONMENT=./.dotfiles_env

USER_PICK=$(ls -p $PRESETS | grep -v / | rofi -show run -dmenu)

if [[ -z $USER_PICK ]]; then
	echo "No user input"
	exit 1
fi

# update the new profile
if [[ $(ls $PRESETS | grep "$USER_PICK") ]]; then
	ln -sf "$PRESETS/$USER_PICK" $ENVIRONMENT
else
	echo "Invalid input"
	exit 1
fi

# will still exit without changes if anything goes wrong in setting rofi

source ./generate.sh
