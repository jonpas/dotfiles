#!/bin/bash

if [ $(hostname) = "loki" ]; then
    layout=$1

    HDMI2cfg="--mode 2560x1080 --rate 75 --primary"
    HDMI1cfg="--mode 1920x1080 --rate 60"
    VGA1cfg="--mode 1680x1050 --rate 60"

    if [ -z "$layout" ]; then
        xrandr \
            --output HDMI2 $HDMI2cfg --pos 0x1050 \
            --output HDMI1 $HDMI1cfg --pos 2560x1050 \
            --output VGA1  $VGA1cfg  --pos 660x0
    elif [ "$layout" = "off" ]; then
        xrandr \
            --output HDMI2 --off \
            --output HDMI1 --off \
            --output VGA1 --primary
    elif [ "$layout" = "right" ]; then
        xrandr \
            --output HDMI2 --off \
            --output HDMI1 $HDMI1cfg --pos 0x0 --primary \
            --output VGA1  $VGA1cfg  --pos 1920x30
    elif [ "$layout" = "left" ]; then
        xrandr \
            --output HDMI2 $HDMI2cfg --pos 0x1050 \
            --output HDMI1 --off \
            --output VGA1  $VGA1cfg  --pos 660x0
    fi
fi

# Wallpaper
feh --no-fehbg --bg-fill '/home/jonpas/Pictures/current_wallpaper'
