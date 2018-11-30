#!/bin/bash

if [ $(hostname) = "loki" ]; then
    xrandr --output HDMI2 --primary --output VGA1 --right-of HDMI2

    # Synergy gets confused with multiple monitors, so restart it
    . ~/.config/i3/synergy.sh

    # Auto-start programs on workspace 1
    i3-msg "workspace 1  ; append_layout ~/.config/i3/workspace-1.json"
    termite -e htop &
    termite -e "watch progress -q" &
    #slack &
    discord &
elif [ $(hostname) = "odin" ]; then
    # Fix issue with wrong (huge) scaling on startup,
    # even though xrandr still reports 1x1
    xrandr --output LVDS-1 --scale 2x2
    xrandr --output LVDS-1 --scale 1x1
fi
