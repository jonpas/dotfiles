#!/bin/bash

if [ $(hostname) != "loki" ]; then
    exit 0
fi

governor=$(cpupower frequency-info -p | grep -o '".*"' | tr -d '"')

if [ ! -z "${BLOCK_BUTTON}" ]; then
    governor_set="powersave"
    if [ "$governor" == "powersave" ]; then
        governor_set="performance"
    fi

    i3-sensible-terminal sudo cpupower frequency-set -g $governor_set

    if [ "$(cpupower frequency-info -p | grep -o '".*"' | tr -d '"')" != "$governor" ]; then
        governor=$governor_set
    fi
fi

echo ""
echo ""
if [ "$governor" == "performance" ]; then
    echo "#b8bb26"
else
    echo "#a9a9a9"
fi
