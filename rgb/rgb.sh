#!/bin/bash

if [ $(hostname) = "loki" ]; then
    state=$1

    if [ "$state" = "on" ]; then
        openrgb -p loki.orp
    elif [ "$state" = "off" ]; then
        openrgb -p off.orp
    fi
fi
