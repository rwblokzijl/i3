#!/bin/bash

# runs the whole file throug bash:
#   treat every line that starts with a ; as a bash command
#   Take everything between {{  }} and apply bash expansion (using echo)
#   echo every normal line (nothing changes)
#   take every line that starts "; import file" and replace it with this script
#   applied to file

INPUT=$1
OUTPUT="${2:-$INPUT}"
WRITE_TO_FILE="${3:-true}"

export SELF=$0

# run () {
ESCAPE="s/'/'\\\''/g if /^[^;]/;"
WRAP="s/^(.*)$/echo '\$1'/ if /^[^;]/;"
RESTORE_EMPTY="s/^$/echo ''/;" # make sure empty lines are carried through
IMPORT='s/^\;\s*import\s*(.*)$/$ENV{SELF} $1 $1 false/;'
ADD_BASH='s/^\;\s*(.*)$/$1/;'
EXPAND='s/{{\s*(.*?)\s*}}/'\''\$(echo '\''echo $1'\'' | bash)'\''/g;'

if $WRITE_TO_FILE; then
    perl -pe "${ESCAPE} ${WRAP} ${RESTORE_EMPTY} ${IMPORT} ${ADD_BASH} ${EXPAND}" $INPUT | bash > $INPUT.bak && mv $INPUT.bak $OUTPUT
else # write to stdout (used for the recursion in $IMPORT)
    perl -pe "${ESCAPE} ${WRAP} ${RESTORE_EMPTY} ${IMPORT} ${ADD_BASH} ${EXPAND}" $INPUT | bash
fi

