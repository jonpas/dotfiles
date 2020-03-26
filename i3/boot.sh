#!/bin/bash

# Set monitor configuration (initially)
. ~/.config/i3/monitor.sh

if [ $(hostname) = "loki" ]; then
    # Start Barrier server
    . ~/dotfiles/barrier/barriers.sh

    # Set monitor configuration again, delayed to ensure refresh rate gets set correctly
    sleep 3 && . ~/.config/i3/monitor.sh &
fi

# Auto-start programs
i3-msg "workspace 10  ; append_layout ~/.config/i3/workspace-10.json"
i3-sensible-terminal -t "Terminal: monitor" &
i3-sensible-terminal -e htop -t "Terminal: htop" &
i3-sensible-terminal -e 'watch progress -q' -t "Terminal: progress" &
i3-sensible-terminal -e 'watch grep \"cpu MHz\" /proc/cpuinfo' -t "Terminal: cpu freq" &

i3-msg "workspace 1  ; append_layout ~/.config/i3/workspace-1.json"
slack &
discord &
teams &
chromium https://www.facebook.com/messages &

i3-msg "workspace 2  ; append_layout ~/.config/i3/workspace-2.json"
firefox &
