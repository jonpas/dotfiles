#!/bin/bash
# Must be owned by root!

con_uuid_ancient="71f4b399-576b-3081-b528-a0eb5b7992f0"
con_uuid_odin="21c07d29-4d48-42c2-819e-c71dd162028f"

if [ $(hostname) = "loki" ]; then
    exit 0
fi

if [ "$CONNECTION_UUID" != $con_uuid_ancient ] && [ "$CONNECTION_UUID" != $con_uuid_odin ]; then
    exit 0
fi

case "$2" in
    up)
        # Wait for nm-applet to start (during boot)
        while [ -z $(pidof nm-applet) ]; do
            sleep 3;
        done

        su jonpas -c "synergyc -d WARNING loki"
        ;;
    down)
        pkill -x synergyc
        ;;
esac
