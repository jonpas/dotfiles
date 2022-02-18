#!/bin/bash

# Set monitor configuration (initially)
. ~/.config/i3/monitor.sh

if [ $(hostname) = "loki" ]; then
    # Start Barrier server
    . ~/dotfiles/barrier/barriers.sh &

    # Set monitor configuration again, delayed to ensure refresh rate gets set correctly
    sleep 3 && . ~/.config/i3/monitor.sh &
fi


# Prepare workspaces
if [ $(hostname) = "loki" ]; then
    i3-msg "workspace 0  ; append_layout ~/.config/i3/workspace-0.json"
fi
i3-msg "workspace 1  ; append_layout ~/.config/i3/workspace-1.json"
i3-msg "workspace 2  ; append_layout ~/.config/i3/workspace-2.json"

# Auto-start programs
i3-sensible-terminal --title "Terminal: htop" htop &
i3-sensible-terminal --title 'Terminal: VM' &
firefox &

if [ $(hostname) = "loki" ]; then
    i3-sensible-terminal --title "Terminal: sensors" watch -t "sensors zenpower-pci-00c3 -A | grep °C" &
    slack &
    discord &
    chromium &
    firefox --new-window about:logo &
else
    i3-sensible-terminal --title "Terminal: sensors" watch -t "sensors coretemp-isa-0000 -A | grep °C" &
fi
