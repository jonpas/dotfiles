#!/bin/bash

if [ $(hostname) != "loki" ]; then
    exit 0
fi

pwrstat="$(sudo pwrstat -status)"
load=$(echo "$pwrstat" | grep -oP "Load\.* \K[0-9]*")
state=$(echo "$pwrstat" | grep -oP "State\.* \K.*")

ups=" "
color="#a9a9a9"

if [ -z "$load" ]; then
    ups+="N/A"
else
    if [ "$state" == "Normal" ]; then
        ups+="${load}W"
    else
        remaining=$(echo "$pwrstat" | grep -oP "Remaining Runtime\.* \K.*")
        ups+="${load}W ($remaining)"
        color="#fb4934"
    fi
fi

echo $ups
echo $ups
echo $color

if [ $load -ge 900 ]; then
    exit 33
fi
