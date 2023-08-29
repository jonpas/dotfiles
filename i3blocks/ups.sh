#!/bin/bash

if [ $(hostname) != "loki" ]; then
    exit 0
fi

pwrstat="$(sudo pwrstat -status)"
load=$(echo "$pwrstat" | grep -oP "Load\.* \K[0-9]*")
state=$(echo "$pwrstat" | grep -oP "State\.* \K.*")
battery=$(echo "$pwrstat" | grep -oP "Battery Capacity\.* \K[0-9]*")

ups=" "
color="#a9a9a9"

if [ -z "$load" ]; then
    ups+="N/A"
else
    ups+="${load}W"
    if [ "$battery" -lt 100 ]; then
        if [ "$battery" -ge 80 ]; then
            ups+="  $battery%"
        elif [ "$battery" -ge 60 ]; then
            ups+="  $battery%"
        elif [ "$battery" -ge 40 ]; then
            ups+="  $battery%"
        elif [ "$battery" -ge 20 ]; then
            ups+="  $battery%"
        else
            ups+="  $battery%"
        fi
    fi

    if [ "$state" != "Normal" ]; then
        remaining=$(echo "$pwrstat" | grep -oP "Remaining Runtime\.* \K.*")
        ups+=" ($remaining)"
        color="#fb4934"
    fi
fi

echo $ups
echo $ups
echo $color

if [ $load -ge 800 ]; then
    exit 33
fi
