#!/bin/bash

if [ $(hostname) != "loki" ]; then
    exit 0
fi

governor=$(cpupower frequency-info -p | grep -o '".*"' | tr -d '"')

if [ ! -z "${BLOCK_BUTTON}" ]; then
    if [ "${BLOCK_BUTTON}" == "3" ]; then
        zenmonitor
    elif [ "${BLOCK_BUTTON}" == "2" ]; then
        notify-send "CPU governor is \"$governor\""
    else
        if [ "$governor" == "schedutil" ]; then
            governor="performance"
        elif [ "$governor" == "performance" ]; then
            governor="schedutil"
        fi
        i3-sensible-terminal -e "sudo cpupower frequency-set -g $governor"
    fi
fi

echo ""
echo ""

if [ "$governor" == "performance" ]; then
    echo "#b8bb26"
else
    echo "#a9a9a9"
fi
