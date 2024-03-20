#!/bin/bash
notify-send "WIFI: " "Scanning..." &
SSID=$(nmcli -f in-use,bars,ssid device wifi list | \
    tail -n +2 | sed -r 's/^\s+/   /; s/^\*\s*/ * /' | \
    rofi -show run -dmenu -p "Select SSID" | \
    sed 's/^[* ]*[^ ]* *//'  | sed 's/\s*$//')

if [[ -z $SSID ]]; then
    exit 0
fi

notify-send "WIFI: " "Connecting to $SSID..." &
RESULT=$(nmcli device wifi connect "$SSID" 2>&1)
if [[ $RESULT != Error* ]]; then
    notify-send "WIFI: " "Connected to $SSID" &
    exit 0 # success
fi
PASSWORD=$(rofi -show run -password -no-fixed-num-lines -dmenu -p "Specify password")
notify-send "WIFI: " "Connecting to $SSID..." &
RESULT=$( nmcli device wifi connect "$SSID" password $PASSWORD 2>&1)
echo $RESULT
while [[ $RESULT == *802-11-wireless-security.psk:* ]]; do
    PASSWORD=$(rofi -show run -password -no-fixed-num-lines -dmenu -p "Incorrect. Specify password")
    RESULT=$( nmcli device wifi connect "$SSID" password $PASSWORD 2>&1)
    echo $RESULT
done
if [[ $RESULT == Error* ]]; then
    notify-send "WIFI: " "Connection failed\n$RESULT" &
    exit 1
fi

notify-send "WIFI: " "Connected to $SSID" &
exit 0
