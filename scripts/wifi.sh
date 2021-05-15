notify-send "WIFI: " "Scanning..."
SSID=$(nmcli -f in-use,bars,ssid device wifi list | \
    tail -n +2 | sed -r 's/^\s+/   /; s/^\*\s*/ * /' | \
    rofi -show run -dmenu -config ~/.config/i3/rofi.conf -p "Select SSID" | \
    sed 's/^[* ]*[^ ]* *//' | tr -d '[:space:]')

if [[ -z $SSID ]]; then
    exit 0
fi

notify-send "WIFI: " "Connecting..."
RESULT=$(nmcli device wifi connect $SSID 2>&1)
if [[ $RESULT != Error* ]]; then
    notify-send "WIFI: " "Connected to $SSID"
    exit 0 # success
fi
PASSWORD=$(rofi -show run -dmenu -config ~/.config/i3/rofi.conf -p "Specify password")
notify-send "WIFI: " "Connecting..."
RESULT=$( nmcli device wifi connect $SSID password $PASSWORD 2>&1)
echo $RESULT
while [[ $RESULT == *802-11-wireless-security.psk:* ]]; do
    PASSWORD=$(rofi -show run -dmenu -config ~/.config/i3/rofi.conf -p "Incorrect. Specify password")
    RESULT=$( nmcli device wifi connect $SSID password $PASSWORD 2>&1)
    echo $RESULT
done
if [[ $RESULT == Error* ]]; then
    notify-send "WIFI: " "Connection failed"
    exit 1
fi

notify-send "WIFI: " "Connected to $SSID"
exit 0
