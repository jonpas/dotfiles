#!/bin/bash

usage=$(mpstat 1 | head -4 | tail -1 | awk '{print int(100-$12+0.5)}')

echo " $usage%"

if [ $usage -ge 95 ]; then
    play --no-show-progress --null --channels 1 synth 0.4 sine 900 # play from SoX
fi

if [ $usage -ge 80 ]; then
    exit 33
fi

exit 0
