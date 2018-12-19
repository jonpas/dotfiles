#!/bin/sh

if [ $(hostname) = "loki" ]; then
    nvidia-modprobe &
elif [ $(hostname) = "odin" ]; then
    xrandr --output LVDS1 --mode 1600x900 &
fi

exec i3
