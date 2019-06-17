#!/bin/bash

usage=$(free | grep Mem | awk '{print int($3/$2 * 100)}')

echo " $usage%"

if [ $usage -ge 95 ]; then
    play --no-show-progress --null --channels 1 synth 0.4 sine 900 # play from SoX
fi

if [ $usage -ge 90 ]; then
    exit 33
fi
