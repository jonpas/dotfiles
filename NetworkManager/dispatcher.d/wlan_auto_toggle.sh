#!/bin/sh
# Must be owned by root!

if [ "$1" = "enp0s25" ]; then
    case "$2" in
        up)
            nmcli radio wifi off
            ;;
        down)
            nmcli radio wifi on
            ;;
    esac
fi
