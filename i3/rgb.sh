#!/bin/bash

if [ $(hostname) = "loki" ]; then
    state=$1

    if [ "$state" = "on" ]; then
        OpenRGB -p ~/dotfiles/OpenRGB/Wraith.orp
    elif [ "$state" = "off" ]; then
        OpenRGB -p ~/dotfiles/OpenRGB/off.orp
    fi
fi
