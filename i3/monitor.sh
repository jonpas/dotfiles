#!/bin/bash

if [ $(hostname) = "loki" ]; then
    xrandr --output HDMI2 --primary --output VGA1 --right-of HDMI2

    # Synergy gets confused with multiple monitors, so restart it
    . ~/.config/i3/synergy.sh
fi

# Auto-start programs on workspace 1
# Sleep between terminal programs to assure correct slot is taken (same terminal)
i3-msg "workspace 1  ; append_layout ~/.config/i3/workspace-1.json"

i3-sensible-terminal -e htop & sleep 0.25
i3-sensible-terminal -e 'watch progress -q' & sleep 0.25
i3-sensible-terminal -e 'watch grep \"cpu MHz\" /proc/cpuinfo' &
slack &
discord &
