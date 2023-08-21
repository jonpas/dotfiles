#!/bin/bash

if [ $(hostname) = "loki" ]; then
    temp=$(sensors | grep -o "Tdie:\s*+[0-9]*" | tail -c -3)
else
    temp=$(sensors | grep -o "Package id 0:\s*+[0-9]*" | tail -c -3)
fi

echo " $temp°C"

if [ $temp -ge 95 ]; then
    play --no-show-progress --null --channels 1 synth 0.4 sine 900 # play from SoX
fi

if [ $temp -ge 90 ]; then
    exit 33
fi
