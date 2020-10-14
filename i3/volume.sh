#!/bin/bash

state=$1

sink=$(pactl info | grep "Default Sink" | cut -d " " -f3)

if [ "$state" = "toggle" ]; then
    pactl set-sink-mute $sink toggle
elif [ ! -z "$state" ]; then
    pactl set-sink-volume $sink $state
fi
