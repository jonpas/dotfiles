#!/bin/bash

if [ $(hostname) = "loki" ]; then
    layout=$1

    LGWcfg="--mode 2560x1080 --rate 75 --primary"
    LGWp="HDMI-0"
    IIYcfg="--mode 1920x1080 --rate 60"
    IIYp="DVI-D-0"
    SSMcfg="--mode 1680x1050 --rate 60 --rotate left"
    SSMp="VGA-0"

    if [ -z "$layout" ]; then
        ddcutil --sn 1130751321527 setvcp 60 0x03
        xrandr \
            --output $LGWp $LGWcfg --panning 2560x1080+0+1080 \
            --output $IIYp $IIYcfg --panning 1920x1080+640+0 \
            --output $SSMp $SSMcfg --panning 1050x1680+2560+480
    elif [ "$layout" = "off" ]; then
        ddcutil --sn 1130751321527 setvcp 60 0x11
        xrandr \
            --output $LGWp --off \
            --output $IIYp --off \
            --output $SSMp --primary
    elif [ "$layout" = "up" ]; then
        ddcutil --sn 1130751321527 setvcp 60 0x03
        xrandr \
            --output $LGWp --off \
            --output $IIYp $IIYcfg --panning 1920x1080+0+0 --primary \
            --output $SSMp $SSMcfg --panning 1050x1680+1920+480
    elif [ "$layout" = "down" ]; then
        ddcutil --sn 1130751321527 setvcp 60 0x11
        xrandr \
            --output $LGWp $LGWcfg --panning 2560x1080+0+1080 \
            --output $IIYp --off \
            --output $SSMp $SSMcfg --panning 1050x1680+2560+480
    fi

    xrandr -s 0  # reset size
fi

# Wallpaper
feh --no-fehbg --bg-fill '/home/jonpas/Pictures/current_wallpaper'
