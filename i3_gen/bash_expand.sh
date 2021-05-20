#!/bin/bash
# Author: Wessel Blokzijl

#                        What this script does:
#
# Allow the use of     !__inline_BASH_commands__!   in every day config files,
# This script is effectively acting as a turing complete preprocessor.
# This script takes an $INPUT file and will apply the following:
#   1. Take everything _between_ {{  }} and apply bash expansion (using echo).
#     Some uses:
#       - {{$HOME}}
#       - {{$(ls /some/dir)}}
#   2. treat every _line_ that starts with a ; as a bash command
#     Some uses:
#       ; source some_script_that_sets_vars.sh
#       ; export $VAR = $(command)
#       ; if [[ -z $VAR ]]; then
#           some config
#       ; else
#           some other config
#       ; fi
#       ;# this is a comment that always works even in json files
#   3. take every line that look like "; import <file>" and replace it with this
#     script applied to that file. This also allows for recursion, so
#     BE CAREFUL!

INPUT=$1
OUTPUT="${2:-$INPUT}"
WRITE_TO_FILE="${3:-true}"

if [[ ! -z $4 ]]; then
    >&2 echo "Too many arguments!"
    exit 1
fi

#                             How its done:
#
# We effectively turn the whole config into a script that echos the desired
# config and then run it in bash. To turn the config into valid bash script we
# use sed to turn every line of the $INPUT into an echo statement that prints
# the desired $OUTPUT line. Technically we use perl for substitutions, but these
# are effectively sed commands:

# this part would output the exact input file after running it through bash:
ESCAPE="s/'/'\\\''/g if /^[^;]/;"       # escape every ' to make the echo work
WRAP="s/^(.*)$/echo '\$1'/ if /^[^;]/;" # wrap normal lines in an echo '$LINE'
RESTORE_EMPTY="s/^$/echo ''/;"          # make sure empty lines aren't skipped

# Take import files and apply this script (recurse)
export BASH_EXPAND_COMMAND=$0
IMPORT='s/^\;\s*import\s*(.*)$/$ENV{BASH_EXPAND_COMMAND} $1 $1 false/;'

# Remove the ; for bash lines
ADD_BASH='s/^\;\s*(.*)$/$1/;'

# apply some echo magic to all between {{ }}. The /g (greedy) at the end makes
# the regex stop matching at the first }} it finds. This allows us to expand
# multiple {{}}s per line (this is why we use perl instead of sed)
EXPAND='s/{{\s*(.*?)\s*}}/'\''\$(echo '\''echo $1'\'' | bash)'\''/g;'

# apply alls substitutions, run through bash and output
if $WRITE_TO_FILE; then
    perl -pe "${ESCAPE} ${WRAP} ${RESTORE_EMPTY} ${IMPORT} ${ADD_BASH} ${EXPAND}" $INPUT | bash > $INPUT.bak && mv $INPUT.bak $OUTPUT
else # write to stdout (used for the recursion in $IMPORT)
    perl -pe "${ESCAPE} ${WRAP} ${RESTORE_EMPTY} ${IMPORT} ${ADD_BASH} ${EXPAND}" $INPUT | bash
fi

