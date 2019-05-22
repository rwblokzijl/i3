#!/bin/bash

pidof /usr/bin/ruby2.3 /usr/local/bin/fusuma >/dev/null
if [[ $? -ne 0 ]] ; then
	fusuma &
	xinput --enable "DLL075B:01 06CB:76AF Touchpad"
else
	killall fusuma
	xinput --disable "DLL075B:01 06CB:76AF Touchpad"
	xdotool mousemove 3200 0
fi
