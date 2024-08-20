#!/bin/bash
# Must be owned by root!

if [ $(hostname) != "odin" ] || [ "$CONNECTION_UUID" != "803105d7-5b6f-3b65-bdb6-5566b2d07a96" ]; then
    exit 0
fi

case "$2" in
    up)
        su jonpas -c "barrierc --disable-crypto -d WARNING 192.168.178.30" # Barrier does not like IPv6
        ;;
    down)
        pkill -x barrierc
        ;;
esac
