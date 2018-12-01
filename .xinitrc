#!/bin/sh

if [ $(hostname) = "loki" ]; then
    nvidia-modprobe &
fi

exec i3
