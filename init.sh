#!/bin/sh
#export HOME=/config

rm /tmp/.X0-lock

/usr/bin/Xvfb $DISPLAY -screen 0 ${DISPLAY_WIDTH}x${DISPLAY_HEIGHT}x24 &
2>&1 /usr/bin/openbox-session &
/startapp.sh "$@"