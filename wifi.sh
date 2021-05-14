SSID=$(nmcli -f in-use,bars,ssid device wifi list ifname wlan0 | \
    tail -n +2 | sed -r 's/^\s+/   /; s/^\*\s*/ * /' | \
    rofi -show run -dmenu -config ~/.config/i3/rofi/rofi.conf -p "Select SSID" | \
    sed 's/^[* ]*[^ ]* *//')

if [[ -z $SSID ]]; then
    exit 0
fi

RESULT=$(nmcli device wifi connect $SSID 2>&1)
if [[ $RESULT != Error* ]]; then
    echo "Connecting..."
    exit 0 # success
fi
PASSWORD=$(rofi -show run -dmenu -config ~/.config/i3/rofi/rofi.conf -p "Specify password")
RESULT=$( nmcli device wifi connect $SSID password $PASSWORD 2>&1)
echo $RESULT
while [[ $RESULT == *802-11-wireless-security.psk:* ]]; do
    PASSWORD=$(rofi -show run -dmenu -config ~/.config/i3/rofi/rofi.conf -p "Incorrect. Specify password")
    RESULT=$( nmcli device wifi connect $SSID password $PASSWORD 2>&1)
    echo $RESULT
done
if [[ $RESULT == Error* ]]; then
    exit 1
fi

exit 0
