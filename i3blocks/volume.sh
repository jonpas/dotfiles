#!/bin/bash

volume=$(pamixer --get-volume)

# Handle waiting for device (pamixer will return empty string)
if [ -z $volume ]; then
    sleep 5 && volume=$(pamixer --get-volume)
fi

if [ $(pamixer --get-mute) = "true" ]; then
    echo " $volume%"
    exit 0
fi

if [ $volume -ge 50 ]; then
    echo " $volume%"
else
    echo " $volume%"
fi
