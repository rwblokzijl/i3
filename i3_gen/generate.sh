#!/bin/bash

# Takes all config files in *.config, applies bash expansion, and move to
# desired config location

GEN_DIR=$HOME/.config/dotfiles_gen
mkdir -p $GEN_DIR

# allows calls from anywhere
cd $(dirname $0)

# load default environment variables
SWITCHER_DEFAULTS="./.default_env" # TODO: move to $GEN_DIR when i3_gen is isolated from i3 config
if [ -f $SWITCHER_DEFAULTS ]; then
    source $SWITCHER_DEFAULTS
    echo Using env vars from $SWITCHER_DEFAULTS
fi

# load extra environment variables set by ./switchconfig.sh
ENVIRONMENT=$GEN_DIR/.dotfiles_env
if [ -f $ENVIRONMENT ]; then
    source $ENVIRONMENT
    echo Overriding with env vars from $ENVIRONMENT
fi

# generate all the configs into `.generated` and link to correct location
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
    ./bash_expand/bash_expand.sh $CONFIG_TEMPLATE > $CONFIG_TEMPLATE.bak && mv $CONFIG_TEMPLATE.bak $GENERATED_CONFIG_LOCATION

    # generate a symlink to the built file in the desired location
    echo "    Linking to $CONFIG_TARGET_LOCATION"
    mkdir -p $(dirname $CONFIG_TARGET_LOCATION)
    ln -sf $GENERATED_CONFIG_LOCATION $CONFIG_TARGET_LOCATION
    echo ""
done

#reload the newly generated config
i3 restart &> /dev/null

