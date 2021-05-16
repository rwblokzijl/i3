#!/bin/bash

# This script generates a new i3 config from the files in the "components"
# directory.


GEN_DIR=$HOME/.config/i3/i3_gen

cd $GEN_DIR

source $GEN_DIR/.preset
cat $GEN_DIR/.preset

#define local folders
I3_CONFIG="$HOME/.config/i3/config"
I3_CONFIG_SPEC="$GEN_DIR/config"

I3_CONFIG_COMPONENTS="$GEN_DIR/components"

#clear the old i3 config file
rm "$I3_CONFIG"
touch "$I3_CONFIG"

#For all the files listed in I3_CONFIG_SPEC file, append them to the config
cat $I3_CONFIG_SPEC | while read line
do
	cat "$I3_CONFIG_COMPONENTS/$line" >> $I3_CONFIG
done

# Expand the BASH-isms in the file
$GEN_DIR/bash_expand.sh $I3_CONFIG

#reload the newly generated config
i3 restart &> /dev/null

