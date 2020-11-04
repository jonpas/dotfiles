#!/bin/bash

if [ $(hostname) = "loki" ]; then
    state=$1

    if [ "$state" = "on" ]; then
        openrgb -p "$(dirname $0)/loki.orp"
    elif [ "$state" = "off" ]; then
        openrgb -p "$(dirname $0)/off.orp"
    fi
fi
