#!/bin/bash

if [ $(hostname) = "loki" ]; then
    state=$1

    if [ "$state" = "on" ]; then
        openrgb -p ~/dotfiles/OpenRGB/Wraith.orp
    elif [ "$state" = "off" ]; then
        openrgb -p ~/dotfiles/OpenRGB/Off.orp
    fi
fi
