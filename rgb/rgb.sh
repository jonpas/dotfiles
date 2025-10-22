#!/bin/bash

if [ $(hostname) = "loki" ]; then
    state=$1

    if [ "$state" = "on" ]; then
        # OpenRGB last as it's slowest
        openrgb -p loki.orp --noautoconnect
    elif [ "$state" = "off" ]; then
        # OpenRGB last as it's slowest
        openrgb -p off.orp --noautoconnect
    fi
fi
