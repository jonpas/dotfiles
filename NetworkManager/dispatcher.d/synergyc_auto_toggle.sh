#!/bin/bash
# Must be owned by root!

con_uuid_ancient="71f4b399-576b-3081-b528-a0eb5b7992f0"
con_uuid_odin="803105d7-5b6f-3b65-bdb6-5566b2d07a96"

if [ $(hostname) = "loki" ]; then
    exit 0
fi

if [ "$CONNECTION_UUID" != "$con_uuid_ancient" ] && [ "$CONNECTION_UUID" != "$con_uuid_odin" ]; then
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
