#!/bin/bash

if [ $(hostname) = "loki" ]; then
    xrandr --output HDMI2 --primary --output VGA1 --right-of HDMI2

    # Synergy gets confused with multiple monitors, so restart it
    . ~/.config/i3/synergy.sh
fi
