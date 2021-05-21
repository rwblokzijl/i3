#!/bin/bash

GEN_DIR=$HOME/.config/dotfiles_gen
mkdir -p $GEN_DIR

# allows calls from anywhere
cd $(dirname $0)

# load defaults
SWITCHER_DEFAULTS="./.default_env" # TODO: move to gen dir, when that is in git
if [ -f $SWITCHER_DEFAULTS ]; then
    source $SWITCHER_DEFAULTS
    echo Using env vars from $SWITCHER_DEFAULTS
fi

# load preset
ENVIRONMENT=$GEN_DIR/.dotfiles_env
if [ -f $ENVIRONMENT ]; then
    source $ENVIRONMENT
    echo Overriding with env vars from $ENVIRONMENT
fi

# generate all the configs into generated and link to correct location
for DIR in *.config
do
    CONFIG_TEMPLATE=$(echo $DIR/*.template)
    BUILD_LOC=$GEN_DIR/.generated/$DIR
    GENERATED_CONFIG_LOCATION=$BUILD_LOC/$(basename $CONFIG_TEMPLATE .template)

    echo --- Generating $DIR ---
    mkdir -p $BUILD_LOC
    # Read CONFIG_TARGET_LOCATION location from first line of the template file
    unset CONFIG_TARGET_LOCATION # clear from previous iteration
    eval $(head -1 $CONFIG_TEMPLATE | sed 's/^;\s*//')
    if [[ -z $CONFIG_TARGET_LOCATION ]]; then
        >&2 echo "error: CONFIG_TARGET_LOCATION not specified at top of $CONFIG_TEMPLATE"
        echo ""
        continue
    fi

    # Generate the config file into the build dir
    ./bash_expand.sh $CONFIG_TEMPLATE $GENERATED_CONFIG_LOCATION

    # generate a symlink to the built file in the desired location
    echo "    Linking to $CONFIG_TARGET_LOCATION"
    mkdir -p $(dirname $CONFIG_TARGET_LOCATION)
    ln -sf $GENERATED_CONFIG_LOCATION $CONFIG_TARGET_LOCATION
    echo ""
done

#reload the newly generated config
i3 restart &> /dev/null

