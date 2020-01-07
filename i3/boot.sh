#!/bin/bash

if [ $(hostname) = "loki" ]; then
    # Set monitor configuration (initially)
    . ~/.config/i3/monitor.sh

    # Start Barrier server
    . ~/dotfiles/barrier/barriers.sh

    # Set monitor configuration again, delayed to ensure refresh rate gets set correctly
    sleep 3 && . ~/.config/i3/monitor.sh &
fi

# Auto-start programs on workspace 1
# Sleep between terminal programs to assure correct slot is taken (same terminal)
i3-msg "workspace 1  ; append_layout ~/.config/i3/workspace-1.json"

i3-sensible-terminal -e htop & sleep 0.25
i3-sensible-terminal -e 'watch progress -q' & sleep 0.25
i3-sensible-terminal -e 'watch grep \"cpu MHz\" /proc/cpuinfo' &
slack &
discord &
