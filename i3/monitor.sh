#!/bin/bash

if [ $(hostname) = "loki" ]; then
    layout=$1

    global="--dpi 96"
    LGWcfg="--mode 2560x1080 --rate 75"
    LGWp="HDMI-A-1"
    IIYcfg="--mode 1920x1080 --rate 60"
    IIYp="DisplayPort-3"
    SSMcfg="--mode 1680x1050 --rate 60 --rotate left"
    SSMp="DVI-D-1"

    if [ -z "$layout" ]; then
        ddcutil --sn 1130751321527 setvcp 60 0x03
        xrandr $global \
            --output $LGWp $LGWcfg --pos 0x1080 --primary \
            --output $IIYp $IIYcfg --pos 640x0 \
            --output $SSMp $SSMcfg --pos 2560x480 --rotate left
    elif [ "$layout" = "right" ]; then
        ddcutil --sn 1130751321527 setvcp 60 0x11
        xrandr $global \
            --output $LGWp --off \
            --output $IIYp --off \
            --output $SSMp --primary
    elif [ "$layout" = "up" ]; then
        ddcutil --sn 1130751321527 setvcp 60 0x03
        xrandr $global \
            --output $LGWp --off \
            --output $SSMp $SSMcfg --pos 0x0 \
            --output $IIYp $IIYcfg --pos 1050x600 --primary
    elif [ "$layout" = "down" ]; then
        ddcutil --sn 1130751321527 setvcp 60 0x11
        xrandr $global \
            --output $LGWp $LGWcfg --pos 0x600 --primary \
            --output $IIYp --off \
            --output $SSMp $SSMcfg --pos 2560x0
    fi
fi

# Wallpaper
feh --no-fehbg --bg-fill '/home/jonpas/Pictures/current_wallpaper'
