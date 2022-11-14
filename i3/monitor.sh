#!/bin/bash

if [ $(hostname) = "loki" ]; then
    layout=$1

    global="--dpi 96"
    p1="DisplayPort-0"
    c1="--mode 3440x1440 --rate 144" # 34" UW 1440p 144 Hz
    s1="1174021700438" # iiyama GB3466WQSU-B1
    s1hdmi1="0x11"
    s1hdmi2="0x12"
    s1dp1="0x0f"
    s1dp2="0x10"

    p2="HDMI-A-0"
    c2="--mode 2560x1080 --rate 60" # 29" UW 1080p 75 Hz
    s2="" # DDC doesn't work - LG 29UM69G (ddcutil detect cannot even read serial)

    p3="DVI-D-0"
    c3="--mode 1920x1080 --rate 60" # 24" 1080p 60 Hz
    s3="1130751321527" # iiyama ProLite B2483HS
    s3hdmi="0x11"
    s3dvi="0x03"
    s3vga="0x01"

    if [ -z "$layout" ]; then
        ddcutil --sn $s1 setvcp 60 $s1dp1
        #ddcutil --sn $s2 setvcp 60 $s2hdmi
        ddcutil --sn $s3 setvcp 60 $s3dvi
        xrandr $global \
            --output $p1 $c1 --pos 0x$(( 1080 - 285 )) --primary \
            --output $p2 $c2 --pos 3440x1080 \
            --output $p3 $c3 --pos 3440x0
    elif [ "$layout" = "right" ]; then
        ddcutil --sn $s1 setvcp 60 $s1dp2
        #ddcutil --sn $s2 setvcp 60 $s2hdmi
        ddcutil --sn $s3 setvcp 60 $s3dvi
        xrandr $global \
            --output $p1 --off \
            --output $p2 $c2 --pos 0x1080 --primary \
            --output $p3 $c3 --pos 0x0
    elif [ "$layout" = "left" ]; then
        ddcutil --sn $s1 setvcp 60 $s1dp1
        #ddcutil --sn $s2 setvcp 60 $s2dp
        ddcutil --sn $s3 setvcp 60 $s3dvi
        xrandr $global \
            --output $p1 $c1 --pos 0x$(( 1080 - 285 )) --primary \
            --output $p2 --off \
            --output $p3 $c3 --pos 3440x0
    elif [ "$layout" = "up" ]; then
        ddcutil --sn $s1 setvcp 60 $s1dp2
        #ddcutil --sn $s2 setvcp 60 $s2dp
        ddcutil --sn $s3 setvcp 60 $s3dvi
        xrandr $global \
            --output $p1 --off \
            --output $p2 --off \
            --output $p3 $c3 --pos 0x0 --primary
    elif [ "$layout" = "down" ]; then
        ddcutil --sn $s1 setvcp 60 $s1dp1
        #ddcutil --sn $s2 setvcp 60 $s2hdmi
        ddcutil --sn $s3 setvcp 60 $s3hdmi
        xrandr $global \
            --output $p1 $c1 --pos 0x0 --primary \
            --output $p2 $c2 --pos 3440x285 \
            --output $p3 --off
    fi
fi

# Wallpaper
feh --no-fehbg --bg-fill '/home/jonpas/Pictures/current_wallpaper'
