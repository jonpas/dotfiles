#!/bin/bash

volume=$(pamixer --get-volume)

if [ $(pamixer --get-mute) = "true" ]; then
    echo " $volume%"
    exit 0
fi

if [ $volume -ge 50 ]; then
    echo " $volume%"
else
    echo " $volume%"
fi
