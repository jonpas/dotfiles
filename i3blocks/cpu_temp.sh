#!/bin/bash

if [ $(hostname) = "loki" ]; then
    temp=$(sensors | grep -o "+[0-9]*" | head -3 | tail -1 | tail -c +2)
else
    temp=$(sensors | grep -o "+[0-9]*" | head -1 | tail -c +2)
fi

echo " $temp°C"

if [ $temp -ge 90 ]; then
    play --no-show-progress --null --channels 1 synth 0.4 sine 900 # play from SoX
fi

if [ $temp -ge 80 ]; then
    exit 33
fi
