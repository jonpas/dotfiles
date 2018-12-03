#!/bin/bash
# Must be owned by root!

if [ $(hostname) != "odin" ] || [ "$CONNECTION_UUID" != "803105d7-5b6f-3b65-bdb6-5566b2d07a96" ]; then
    exit 0
fi

case "$2" in
    up)
        # Wait for nm-applet to start (during boot)
        while [ -z $(pidof nm-applet) ]; do
            sleep 3;
        done

        su jonpas -c "synergyc -d WARNING 192.168.178.30" # Synergy does not like IPv6
        ;;
    down)
        pkill -x synergyc
        ;;
esac
