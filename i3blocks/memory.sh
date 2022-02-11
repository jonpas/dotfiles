#!/bin/bash

usage=$(free | grep Mem | awk '{print int($3/$2 * 100)}')

echo " $usage%"

if [ $usage -ge 90 ]; then
    notify-send -u critical "MEM CRITICAL" "Memory at $usage%"
fi

if [ $usage -ge 85 ]; then
    exit 33
fi
