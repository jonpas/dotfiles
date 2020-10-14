#!/bin/bash

state=$1

if [ "$state" = "toggle" ]; then
    sink=$(pactl info | grep "Default Sink" | cut -d " " -f3)
    pactl set-sink-mute $sink toggle  # Toggles all sources properly unlike amixer
elif [ ! -z "$state" ]; then
    amixer -q set Master $state
fi

pkill -RTMIN+2 i3blocks
