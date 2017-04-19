#!/bin/bash

volume=$(amixer get Master | grep -E -o '[0-9]{1,3}?%' | head -c -2)

if [ $(amixer get Master | tail -c -5 | head -c -2) == "off" ]; then
    echo " $volume"
    exit 0
fi

if [ $volume -ge 50 ]; then
    echo " $volume"
else
    echo " $volume"
fi
