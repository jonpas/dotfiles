#!/bin/bash

if [ $(hostname) = "loki" ]; then
    state=$1

    # G710+ find LED class
    g710_vpid="046D:C24D"
    g710_keys=$(find /sys/class/leds/ -lname "*$g710_vpid*:white:keys")
    g710_wasd=$(find /sys/class/leds/ -lname "*$g710_vpid*:white:wasd")

    if [ "$state" = "on" ]; then
        # G710+ Driver Kernel API
        echo 2 > $g710_keys/brightness
        echo 3 > $g710_wasd/brightness

        # OpenRGB last as it's slowest
        openrgb -p loki.orp --noautoconnect
    elif [ "$state" = "off" ]; then
        # G710+ Driver Kernel API
        echo 0 > $g710_keys/brightness
        echo 0 > $g710_wasd/brightness

        # OpenRGB last as it's slowest
        openrgb -p off.orp --noautoconnect
    fi
fi
