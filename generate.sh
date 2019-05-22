#!/bin/bash

# This script generates a new i3 config from the files in the "profiles"
# directory.

cd $HOME/.config/i3

#define local folders
I3_CONFIG="./config"
I3_VARS="./localvars"
I3_PROFILE="./profile"

I3_PROFILES="./profiles"

#clear the old i3 config file
rm "$I3_CONFIG"
touch "$I3_CONFIG"

#Start with the local variables (screen sizes and rig identifier)
if [[ -f $I3_VARS ]]; then
	cat "$I3_VARS" >> $I3_CONFIG
fi

#For all the files listed in I3_PROFILE file, append them to the config
cat $I3_PROFILE | while read line
do
	cat "$I3_PROFILES/$line" >> $I3_CONFIG
done

#reload the newly generated config
i3 restart &> /dev/null
