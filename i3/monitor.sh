#!/bin/bash

if [ $(hostname) = "loki" ]; then
    layout=$1

    global="--dpi 96"
    p1="DisplayPort-0"
    c1="--mode 3440x1440 --rate 144" # 34" UW 1440p 144 Hz
    s1="--sn 1174021700438" # iiyama GB3466WQSU-B1
    s1hdmi1="x60 0x11"
    s1hdmi2="x60 0x12"
    s1dp1="x60 0x0f"
    s1dp2="x60 0x10"

    p2="HDMI-A-0"
    c2="--mode 2560x1080 --rate 60" # 29" UW 1080p 75 Hz
    s2="--mfg GSM" # no serial, only works with ddcutil v2.0.0 with side channel information
    s2hdmi="xF4 0x90 --i2c-source-addr=x50 --noverify"
    s2dp="xF4 0xC0 --i2c-source-addr=x50 --noverify"
    s2usbc="xF4 0xE0 --i2c-source-addr=x50 --noverify"

    p3="DVI-D-0"
    c3="--mode 1920x1080 --rate 60" # 24" 1080p 60 Hz
    s3="--sn 1130751321527" # iiyama ProLite B2483HS
    s3hdmi="x60 0x11"
    s3dvi="x60 0x03"
    s3vga="x60 0x01"

    keepon="false"

    if [ -z "$layout" ]; then
        ddcutil $s1 setvcp $s1dp1 &
        ddcutil $s2 setvcp $s2hdmi &
        ddcutil $s3 setvcp $s3dvi
        xrandr $global \
            --output $p1 $c1 --pos 0x$(( 1080 - 285 )) --primary \
            --output $p2 $c2 --pos 3440x1080 \
            --output $p3 $c3 --pos 3440x0
    elif [ "$layout" = "right" ]; then
        ddcutil $s1 setvcp $s1dp2 &
        ddcutil $s2 setvcp $s2hdmi &
        ddcutil $s3 setvcp $s3dvi
        xrandr $global \
            --output $p1 --off \
            --output $p2 $c2 --pos 0x1080 --primary \
            --output $p3 $c3 --pos 0x0
    elif [ "$layout" = "left" ]; then
        ddcutil $s1 setvcp $s1dp1 &
        ddcutil $s2 setvcp $s2dp &
        ddcutil $s3 setvcp $s3dvi
        xrandr $global \
            --output $p1 $c1 --pos 0x$(( 1080 - 285 )) --primary \
            --output $p2 --off \
            --output $p3 $c3 --pos 3440x0
    elif [ "$layout" = "up" ]; then
        ddcutil $s1 setvcp $s1dp2 &
        ddcutil $s2 setvcp $s2dp &
        ddcutil $s3 setvcp $s3dvi
        xrandr $global \
            --output $p1 --off \
            --output $p2 --off \
            --output $p3 $c3 --pos 0x0 --primary
    elif [ "$layout" = "down" ]; then
        ddcutil $s1 setvcp $s1dp1 &
        ddcutil $s2 setvcp $s2hdmi &
        ddcutil $s3 setvcp $s3hdmi
        xrandr $global \
            --output $p1 $c1 --pos 0x0 --primary \
            --output $p2 $c2 --pos 3440x285 \
            --output $p3 --off
    elif [ "$layout" = "meet" ]; then
        ddcutil $s1 setvcp $s1dp1 &
        ddcutil $s2 setvcp $s2hdmi &
        ddcutil $s3 setvcp $s3dvi
        xrandr $global \
            --output $p1 $c1 --pos 0x$(( 1080 - 285 )) --primary \
            --output $p2 $c2 --pos 3440x1080 \
            --output $p3 $c3 --pos 3440x0
        keepon="true"
    fi

    if [ "$keepon" = "true" ]; then
        dunstctl set-paused true
        xset -dpms
        xset s noblank
        xset s off
    else
        dunstctl set-paused false
        xset +dpms
        xset s blank
        xset s on
    fi
fi

# Wallpaper
feh --no-fehbg --bg-fill '/home/jonpas/Pictures/current_wallpaper'
