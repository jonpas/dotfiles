#!/bin/bash

if [ $(hostname) = "loki" ]; then
    xrandr --output HDMI2 --primary --output VGA1 --right-of HDMI2
    synergys -d WARNING --enable-crypto # After setting monitors, so Synergy doesn't get confused
fi
