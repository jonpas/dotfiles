#!/bin/bash

dark=$1

# Single instance (xss-lock may re-trigger while already locked)
exec 9>/tmp/i3lock.lock
flock -n 9 || exit 0

# Create lock screen
target=$(xrandr | tr "," "\n" | sed -n '2p' | tail -c +10)
targetX=$(awk '{print $1}' <<< $target)
targetY=$(awk '{print $3}' <<< $target)

resizeX=$(( $targetX / 20 ))
resizeY=$(( $targetY / 20 ))

scrot -o -q 1 /tmp/screenshot.jpg
convert /tmp/screenshot.jpg -resize ${resizeX}x${resizeY} -scale ${targetX}x${targetY} /tmp/screenshotblur.png

# Lock
if [ "$dark" = "true" ]; then # loki-only
    xset dpms force suspend &&
    ~/dotfiles/rgb/rgb.sh off &
fi

dbus-send /org/freedesktop/ScreenSaver org.freedesktop.ScreenSaver.ActiveChanged

if [ $(hostname) = "odin" ]; then
    light-locker-command -l # LightDM-compatible locker (avoid double lock with LightDM+i3lock, NOT blocking)
else
    i3lock -i /tmp/screenshotblur.png --nofork # no fork waits for unlock to continue executing (blocking)
fi

# Unlock
if [ "$dark" = "true" ]; then # loki-only (i3lock)
    ~/dotfiles/rgb/rgb.sh on
fi
