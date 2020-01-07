#!/bin/bash

if [ $(hostname) = "loki" ]; then
    # Run on every xrandr/mons change to force refresh rate
    xrandr --output HDMI2 --primary --mode 2560x1080 --rate 75 --output VGA1 --right-of HDMI2
fi
