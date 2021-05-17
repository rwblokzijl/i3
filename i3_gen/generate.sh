#!/bin/bash

# This script generates a new i3 config from the files in the "components"
# directory.

GEN_DIR=$HOME/.config/i3/i3_gen
cd $GEN_DIR

# load defaults
SWITCHER_DEFAULTS="./switcher_defaults"
if [ -f $SWITCHER_DEFAULTS ]; then
    source $SWITCHER_DEFAULTS
    cat $SWITCHER_DEFAULTS
fi

# load preset
PROFILE=$GEN_DIR/.preset
if [ -f $PROFILE ]; then
    source $PROFILE
    cat $PROFILE
fi

# generate all the configs
for DIR in *.config
do
    echo --- Generating $DIR ---
    CONFIG_SOURCE=$DIR/*.template
    CONFIG_TARGET=../$(basename $CONFIG_SOURCE .template)
    ./bash_expand.sh $CONFIG_SOURCE $CONFIG_TARGET
done

#reload the newly generated config
i3 restart &> /dev/null

