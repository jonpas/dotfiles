#!/bin/bash

if [ $(hostname) = "loki" ]; then
    xrandr --output HDMI2 --primary --mode 2560x1080 --rate 75 --output VGA1 --right-of HDMI2

    # Start Barrier server
    . ~/dotfiles/barrier/barriers.sh
fi

# Auto-start programs on workspace 1
# Sleep between terminal programs to assure correct slot is taken (same terminal)
i3-msg "workspace 1  ; append_layout ~/.config/i3/workspace-1.json"

i3-sensible-terminal -e htop & sleep 0.25
i3-sensible-terminal -e 'watch progress -q' & sleep 0.25
i3-sensible-terminal -e 'watch grep \"cpu MHz\" /proc/cpuinfo' &
slack &
discord &
