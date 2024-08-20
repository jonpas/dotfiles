#!/bin/bash
# Must be owned by root!

if [ "$1" = "enp0s31f6" ]; then
    case "$2" in
        up)
            nmcli radio wifi off
            ;;
        down)
            nmcli radio wifi on
            ;;
    esac
fi
