#!/bin/bash

OPTION1="connect"
OPTION2="break"
OPTIONS="$OPTION1\n$OPTION2"

SELECTED="$(echo -e "$OPTIONS" | rofi -config ~/.config/i3/rofi.conf -lines 2 -dmenu -p "Wireguard VPN")"

case $SELECTED in
    $OPTION1)
        PROFILE=$(basename -s .conf $(ls /etc/wireguard) | \
            rofi -config ~/.config/i3/rofi.conf -dmenu -p "Select to connect"
        )
        COMMAND="wg-quick up $PROFILE"
        SUCCESS="CONNECTED to $PROFILE"
        ;;
    $OPTION2)
        PROFILE=$( wg 2>&1 | grep interface | cut -f5 -d " " | sed 's/://g' | \
            rofi -config ~/.config/i3/rofi.conf -no-custom -dmenu -p "Select to disconnect"
        )
        COMMAND="wg-quick down $PROFILE"
        SUCCESS="$PROFILE DISCONNECTED"
        ;;
    *)
        exit
        ;;
esac

if [[ -z $PROFILE ]]; then
    # No option provided
    exit
fi

attempt_connect () {
    PASS=$(rofi -config ~/.config/i3/rofi.conf \
        -dmenu -mesg "$COMMAND" -password -no-fixed-num-lines \
        -p "Enter password"
    )
    if [[ -z $PASS ]]; then
        exit
    fi
    OUTPUT=$(echo -e "$PASS" | sudo -S -k $COMMAND 2>&1)
    if [[ $OUTPUT == *"incorrect"* ]]; then
        return
    elif [[ $OUTPUT != *"no password was provided"* ]]; then
        notify-send "VPN: " "$SUCCESS"
        exit 0
    fi
}

for i in {1..3}; do attempt_connect; done

if [[ $OUTPUT == *"incorrect"* ]]; then
    notify-send "VPN: " "TOO MANY ATTEMPTS"
    exit
fi

if [ $? -ne 0 ]; then
    notify-send "$OUTPUT"
fi
