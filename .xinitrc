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

    # Enable keyboard repeat (better Barrier/Synergy compatibility)
    xset r on

    # Load OpenRGB profile
    OpenRGB --profile ~/dotfiles/OpenRGB/Wraith.orp
fi

exec i3
