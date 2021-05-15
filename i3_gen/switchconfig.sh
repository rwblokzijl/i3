#!/bin/bash

cd $HOME/.config/i3/i3_gen

CONFIG_SPEC="./config"
CONFIG_COMPONENTS="./components"
VARS="./localvars"
SWITCHER_DEFAULTS="./switcher_defaults"
PRESETS="./presets"

PROFILE=$(ls -p $PRESETS | grep -v / | rofi -show run -dmenu -config ~/.config/i3/rofi.conf)

if [[ -z $PROFILE ]]; then
	#no user input
	exit 1
fi

if [[ $(ls $PRESETS | grep "$PROFILE") ]]; then
	source "$PRESETS/$PROFILE"
else
	echo "Invalid input"
	exit 1
fi

if [ -f $SWITCHER_DEFAULTS ]; then
	source $SWITCHER_DEFAULTS
else
	echo "i3/baseconfigs doesn't exist using defaults"
fi

#check if options set
if [ -z $BASE ]; then
	BASE=default
fi

if [ -z $COLORS ]; then
	echo Colors not set
	exit 1
fi

if [ -z $KEYBINDS ]; then
	KEYBINDS=default
fi

if [ -z $MACHINE ]; then
	MACHINE=$(hostname)
fi

if [ -z $STYLE ]; then
	echo Style not set
	exit 1
fi

# check if files exist
if ! [ -f $CONFIG_COMPONENTS/base/$BASE ]; then
	echo "Base file $BASE doesn't exist"
	exit 1
fi

if ! [ -f $CONFIG_COMPONENTS/colors/$COLORS ]; then
	echo "Colors file $COLORS doesn't exist"
	exit 1
fi

if ! [ -f $CONFIG_COMPONENTS/keybinds/$KEYBINDS ]; then
	echo "Keybinds file $KEYBINDS doesn't exist"
	exit 1
fi

if ! [ -f $CONFIG_COMPONENTS/machine/$MACHINE ]; then
	echo "Machine file $MACHINE doesn't exist"
	exit 1
fi

if ! [ -f $CONFIG_COMPONENTS/style/$STYLE ]; then
	echo "Style file $STYLE doesn't exist"
	exit 1
fi

# will still exit without changes if anything goes wrong in setting rofi
source ./rofi/generate.sh

rm "$CONFIG_SPEC"

# order of configs can be changed here
echo "base/$BASE" > $CONFIG_SPEC
echo "colors/$COLORS" >> $CONFIG_SPEC
echo "keybinds/$KEYBINDS" >> $CONFIG_SPEC
echo "machine/$MACHINE" >> $CONFIG_SPEC
echo "style/$STYLE" >> $CONFIG_SPEC

echo "set \$HEIGHT $HEIGHT" > $VARS
echo "set \$WIDTH $WIDTH" >> $VARS
echo "set \$MACHINE $MACHINE" >> $VARS

source ./generate.sh
