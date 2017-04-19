#!/bin/sh
# Must be owned by root!

if [ "$CONNECTION_UUID" = "71f4b399-576b-3081-b528-a0eb5b7992f0" ]; then
    case "$2" in
        up)
            # Wait for nm-applet to start (during boot)
            while [ -z $(pidof nm-applet) ]; do
                sleep 3;
            done

            su jonpas -c "synergyc -d WARNING --enable-crypto 192.168.1.30"
            ;;
        down)
            pkill -x synergyc
            ;;
    esac
fi
