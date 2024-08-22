#!/bin/bash

pwrstat="$(pwrstat -status)"
load=$(echo "$pwrstat" | grep -oP "Load\.* \K[0-9]*")
pwrstate=$(echo "$pwrstat" | grep -oP "State\.* \K.*")
battery=$(echo "$pwrstat" | grep -oP "Battery Capacity\.* \K[0-9]*")

ups=" "
state="Idle"

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

    if [ "$pwrstate" != "Normal" ]; then
        remaining=$(echo "$pwrstat" | grep -oP "Remaining Runtime\.* \K.*")
        ups+=" ($remaining)"
        state="Critical"
    fi
fi

if [ $load -ge 800 ]; then
    state="Critical"
fi

echo {\"state\": \"$state\", \"text\": \"$ups\"}
