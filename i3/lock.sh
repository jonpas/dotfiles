#!/bin/bash

target=$(xrandr | tr "," "\n" | sed -n '2p' | tail -c +10)
targetX=$(awk '{print $1}' <<< $target)
targetY=$(awk '{print $3}' <<< $target)

resizeX=$(( $targetX / 20 ))
resizeY=$(( $targetY / 20 ))

scrot -o -q 1 /tmp/screenshot.jpg
convert /tmp/screenshot.jpg -resize ${resizeX}x${resizeY} -scale ${targetX}x${targetY} /tmp/screenshotblur.png

i3lock -i /tmp/screenshotblur.png --nofork # no fork waits for unlock to continue executing

# Unlock
if [ $(hostname) = "loki" ]; then
    . ~/.config/i3/rgb.sh on
fi
