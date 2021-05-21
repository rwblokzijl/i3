#!/bin/bash

GEN_DIR=$HOME/.config/dotfiles_gen

cd $(dirname $0)

PRESETS="$(pwd)/presets"
ENVIRONMENT=$GEN_DIR/.dotfiles_env

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

source ./generate.sh
