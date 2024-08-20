#!/bin/bash

if [ $(hostname) = "loki" ]; then
    exit 0
fi

bat=${1:-0}

stat=$(cat /sys/class/power_supply/BAT$bat/status)
charge=$(cat /sys/class/power_supply/BAT$bat/capacity)

if [[ $stat == "Full" ]]; then
    echo " $charge%"
    exit 0
fi

remaining=$(acpi -b | awk -F '[,]' -v bat="$bat" 'NR==bat+1{print $3}' | cut -c 2- | head -c 5)
if [ ! -z "$remaining" ]; then
    remaining=" ($remaining)"
fi

if [[ $stat == "Charging" ]]; then
    echo " $charge%$remaining"
    exit 0
fi

if [ $charge -ge 80 ]; then
    echo " $charge%$remaining"
    exit 0
fi

if [ $charge -ge 60 ]; then
    echo " $charge%$remaining"
    exit 0
fi

if [ $charge -ge 40 ]; then
    echo " $charge%$remaining"
    exit 0
fi

if [ $charge -ge 20 ]; then
    echo " $charge%$remaining"
    exit 0
fi

echo " $charge%$remaining"
exit 33
