#!/bin/sh

# X11 xinitrc.d scripts (default)
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# User programs
if [ $(hostname) = "loki" ]; then
    # Load Nvidia driver (for later binding)
    nvidia-modprobe &

    # Enable keyboard repeat (better Synergy compatibility)
    xset r on
elif [ $(hostname) = "odin" ]; then
    xrandr --output LVDS1 --mode 1600x900 &
fi

exec i3
