#!/bin/bash

dark=$1

# Create lock screen
target=$(xrandr | tr "," "\n" | sed -n '2p' | tail -c +10)
targetX=$(awk '{print $1}' <<< $target)
targetY=$(awk '{print $3}' <<< $target)

resizeX=$(( $targetX / 20 ))
resizeY=$(( $targetY / 20 ))

scrot -o -q 1 /tmp/screenshot.jpg
convert /tmp/screenshot.jpg -resize ${resizeX}x${resizeY} -scale ${targetX}x${targetY} /tmp/screenshotblur.png

# Lock
if [ "$dark" = "true" ]; then
    xset dpms force suspend &&
    ~/dotfiles/rgb/rgb.sh off &
fi

if [ $(hostname) = "odin" ]; then
    bt=$(rofi-bluetooth --status)
    if [[ "${bt:0:2}" == "" ]]; then
        bluetooth_off=true
    fi
fi

if [ $(hostname) = "odin" ]; then
    light-locker-command -l # LightDM-compatible locker (avoid double lock with LightDM+i3lock)
else
    i3lock -i /tmp/screenshotblur.png --nofork # no fork waits for unlock to continue executing
fi

if [ ! -z $bluetooth_off ]; then
    bluetoothctl power off
fi

# Unlock
if [ "$dark" = "true" ]; then
    ~/dotfiles/rgb/rgb.sh on
fi
