#!/bin/bash

if [ $(hostname) = "loki" ]; then
    layout=$1

    LGWcfg="--mode 2560x1080 --rate 75 --primary"
    LGWp="HDMI-0"
    AOCcfg="--mode 1920x1080 --rate 60"
    AOCp="DVI-D-0"
    SSMcfg="--mode 1680x1050 --rate 60"
    SSMp="VGA-0"

    if [ -z "$layout" ]; then
        ddcutil --sn CTNB9HA004317 setvcp 60 0x04
        xrandr \
            --output $LGWp $LGWcfg --pos 0x1050 \
            --output $AOCp $AOCcfg --pos 2560x1050 \
            --output $SSMp $SSMcfg --pos 660x0
    elif [ "$layout" = "off" ]; then
        ddcutil --sn CTNB9HA004317 setvcp 60 0x03
        xrandr \
            --output $LGWp --off \
            --output $AOCp --off #\
            --output $SSMp --primary
    elif [ "$layout" = "right" ]; then
        ddcutil --sn CTNB9HA004317 setvcp 60 0x04
        xrandr \
            --output $LGWp --off \
            --output $AOCp $AOCcfg --pos 0x0 --primary \
            --output $SSMp $SSMcfg  --pos 1920x30
    elif [ "$layout" = "left" ]; then
        ddcutil --sn CTNB9HA004317 setvcp 60 0x03
        xrandr \
            --output $LGWp $LGWcfg --pos 0x1050 \
            --output $AOCp --off \
            --output $SSMp $SSMcfg  --pos 660x0
    fi
fi

# Wallpaper
feh --no-fehbg --bg-fill '/home/jonpas/Pictures/current_wallpaper'
