#!/bin/bash

dark=$1
rundir="/run/user/$(id -u)"

# Single instance (xss-lock may re-trigger while already locked)
exec 9>"$rundir/i3lock.lock"
flock -n 9 || exit 0

# Create lock screen
scrot --format jpg -q 1 - \
    | ffmpeg -loglevel error -y -f jpeg_pipe -i - \
        -vf 'format=rgb24,scale=ceil(iw/20):ceil(ih/20):flags=lanczos,scale=iw*20:ih*20:flags=neighbor' \
        -compression_level 0 "$rundir/lockscreen.png"

# Lock
if [ "$dark" = "true" ]; then # loki-only
    xset dpms force suspend &&
    ~/dotfiles/rgb/rgb.sh off &
fi

dbus-send /org/freedesktop/ScreenSaver org.freedesktop.ScreenSaver.ActiveChanged

if [ $(hostname) = "odin" ]; then
    light-locker-command -l # LightDM-compatible locker (avoid double lock with LightDM+i3lock, NOT blocking)
else
    i3lock -i "$rundir/lockscreen.png" --nofork # no fork waits for unlock to continue executing (blocking)
fi

# Unlock
rm "$rundir/lockscreen.png"

if [ "$dark" = "true" ]; then # loki-only (i3lock)
    ~/dotfiles/rgb/rgb.sh on
fi
