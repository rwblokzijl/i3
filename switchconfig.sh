#!/bin/bash

cd $HOME/.config/i3

PROFILE_FILE="./profile"
PROFILES="./profiles"
VARS="./localvars"

PROFILE=$(ls -p $PROFILES | grep -v / | rofi -show run -dmenu -config ~/.config/i3/rofi/rofi.conf)

if [[ -z $PROFILE ]]; then
	#no user input
	exit 1
fi

if [[ $(ls $PROFILES | grep "$PROFILE") ]]; then
	source "$PROFILES/$PROFILE"
else
	echo "Invalid input"
	exit 1
fi

if [ -f ./baseconfigs ]; then
	source ./baseconfigs
else
	echo "i3/baseconfigs doesn't exist"
	exit 1
fi

#check if options set
if [ -z $BASE ]; then
	echo Base not set
	exit 1
fi

if [ -z $COLORS ]; then
	echo Colors not set
	exit 1
fi

if [ -z $SHORTCUTS ]; then
	echo Shortcuts not set
	exit 1
fi

if [ -z $PERSONAL ]; then
	echo Personal not set
	exit 1
fi

if [ -z $STYLE ]; then
	echo Style not set
	exit 1
fi

# check if configs exist
if ! [ -f $PROFILES/base/$BASE ]; then
	echo "Base file $BASE doesn't exist"
	exit 1
fi

if ! [ -f $PROFILES/colors/$COLORS ]; then
	echo "Colors file $COLORS doesn't exist"
	exit 1
fi

if ! [ -f $PROFILES/shortcuts/$SHORTCUTS ]; then
	echo "Shortcuts file $SHORTCUTS doesn't exist"
	exit 1
fi

if ! [ -f $PROFILES/personal/$PERSONAL ]; then
	echo "Personal file $PERSONAL doesn't exist"
	exit 1
fi

if ! [ -f $PROFILES/style/$STYLE ]; then
	echo "Style file $STYLE doesn't exist"
	exit 1
fi

# will still exit without changes if anything goes wrong in setting rofi
source ./rofi/generate.sh

rm "$PROFILE_FILE"

# order of configs can be changed here
echo "base/$BASE" > $PROFILE_FILE
echo "colors/$COLORS" >> $PROFILE_FILE
echo "shortcuts/$SHORTCUTS" >> $PROFILE_FILE
echo "personal/$PERSONAL" >> $PROFILE_FILE
echo "style/$STYLE" >> $PROFILE_FILE

echo "set \$HEIGHT $HEIGHT" > $VARS
echo "set \$WIDTH $WIDTH" >> $VARS
echo "set \$MACHINE $MACHINE" >> $VARS

source ./generate.sh
