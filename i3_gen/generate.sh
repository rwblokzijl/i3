#!/bin/bash

# This script generates a new i3 config from the files in the "profiles"
# directory.

cd $HOME/.config/i3/i3_gen

#define local folders
I3_CONFIG="../config"
I3_CONFIG_SPEC="./config"

I3_CONFIG_COMPONENTS="./components"

#clear the old i3 config file
rm "$I3_CONFIG"
touch "$I3_CONFIG"

#For all the files listed in I3_CONFIG_SPEC file, append them to the config
cat $I3_CONFIG_SPEC | while read line
do
	cat "$I3_CONFIG_COMPONENTS/$line" >> $I3_CONFIG
done

# Take everything between {{  }} and apply bash expansion
ESCAPE="s/'/'\\\''/g;"
PREPEND="s/^/echo '/;"
EXPAND='s/{{\s*\(.*\)\s*}}/'\''$(echo '\''echo \1'\'' | bash)'\''/;'
APPEND="s/$/'/"
EXECUTE="e"
sed -i "${ESCAPE} ${PREPEND} ${EXPAND} ${APPEND} ${EXECUTE}" $I3_CONFIG

#reload the newly generated config
i3 restart &> /dev/null
