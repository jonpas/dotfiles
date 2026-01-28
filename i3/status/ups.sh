#!/bin/bash

load="$(upsc cyberpower@tyr ups.load)"
battery="$(upsc cyberpower@tyr battery.charge)"
upsstatus="$(upsc cyberpower@tyr ups.status)"

ups=" "
state="Idle"

if [ -z "$load" ]; then
    ups+="N/A"
else
    ups+="${load}%"
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

    if [ "$upsstatus" != "OL" ] && [ "$upsstatus" != "OL CHRG" ]; then
        remaining="$(upsc cyberpower@tyr battery.runtime)"
        ups+=" ($remaining)"
        state="Critical"
    fi
fi

if [ $load -ge 90 ]; then
    state="Critical"
fi

echo {\"state\": \"$state\", \"text\": \"$ups\"}
