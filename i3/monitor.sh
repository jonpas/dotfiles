#!/bin/bash

if [ $(hostname) = "loki" ]; then
    xrandr --output HDMI2 --primary --output VGA1 --right-of HDMI2

    # Synergy gets confused with multiple monitors, so restart it
    . ~/.config/i3/synergy.sh

    # Auto-start programs on workspace 1
    i3-msg "workspace 1  ; append_layout ~/.config/i3/workspace-1.json"
    termite -e htop &
    slack &
    discord &
fi
