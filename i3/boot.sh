#!/bin/bash

# Set monitor configuration (initially)
. ~/.config/i3/monitor.sh

if [ $(hostname) = "loki" ]; then
    # Start Barrier server
    . ~/dotfiles/barrier/barriers.sh &

    # Set monitor configuration again, delayed to ensure refresh rate gets set correctly
    sleep 3 && . ~/.config/i3/monitor.sh &

    # Enable keyboard repeat (better Barrier/Synergy compatibility)
    xset r on

    # Load OpenRGB profile
    ~/dotfiles/rgb/rgb.sh on

    # Lock on ACPI events (suspend / hibernate / screen blank)
    xss-lock --transfer-sleep-lock -- ~/.config/i3/lock.sh &
fi


# Prepare workspaces
if [ $(hostname) = "loki" ]; then
    i3-msg "workspace 0  ; append_layout ~/.config/i3/workspace-0.json"
    i3-msg "workspace 1  ; append_layout ~/.config/i3/workspace-1.json"
    i3-msg "workspace 2  ; append_layout ~/.config/i3/workspace-2.json"
elif [ $(hostname) = "odin" ]; then
    i3-msg "workspace 1  ; append_layout ~/.config/i3/workspace-1-odin.json"
fi

# Auto-start programs
i3-sensible-terminal --title "Terminal: htop" htop &

if [ $(hostname) = "loki" ]; then
    i3-sensible-terminal --title 'Terminal: VM' &
    firefox &

    i3-sensible-terminal --title "Terminal: sensors" watch -t "sensors zenpower-pci-00c3 -A | grep °C" &
    slack &
    discord &
    chromium &
    firefox --new-window about:logo &
elif [ $(hostname) = "odin" ]; then
    i3-sensible-terminal --title "Terminal: sensors" watch -t "sensors coretemp-isa-0000 -A | grep °C" &
    i3-sensible-terminal &
fi
