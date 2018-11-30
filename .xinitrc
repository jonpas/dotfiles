#!/bin/sh

if [ $(hostname) = "odin" ]; then
    nvidia-modprobe &
fi

exec i3
