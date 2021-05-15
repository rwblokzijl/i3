ROFI_CONFIG="../rofi.conf"
ROFI_PROFILES="./rofi/profiles"

# check if vars are set
if [ -z $COLORS ]; then
	echo "Missing COLORS for rofi, something went wrong somewhere it shouldn't have 1"
	exit 1
fi

if [ -z $STYLE ]; then
	echo "Missing STYLE for rofi, something went wrong somewhere it shouldn't have 1"
	exit 1
fi

if [ -z $HEIGHT ]; then
	echo "Missing HEIGHT resolution for rofi, set it in i3/baseconfigs, using default"
	HEIGHT=$(xrandr | grep " connected" | sed -n '1 p' | tr 'x+' " " | awk '{print $4;}')
fi

# check if vars ar proper values
if ! [ -f $ROFI_PROFILES/colors/$COLORS ]; then
	echo "missing colors file for rofi, something went wrong somewhere it shouldn't have 2"
	exit 1
fi

if ! [ -f $ROFI_PROFILES/style/$STYLE ]; then
	echo "missing style file for rofi, something went wrong somewhere it shouldn't have 2"
	exit 1
fi

if ! [ -f $ROFI_PROFILES/size/$HEIGHT ]; then
	echo "Missing HEIGHT resolution for rofi, make sure $HEIGHT exists in .profile/size"
	exit 1
fi

rm "$ROFI_CONFIG"
touch "$ROFI_CONFIG"

cat $ROFI_PROFILES/colors/$COLORS >> $ROFI_CONFIG
cat $ROFI_PROFILES/style/$STYLE >> $ROFI_CONFIG
cat $ROFI_PROFILES/size/$HEIGHT >> $ROFI_CONFIG

