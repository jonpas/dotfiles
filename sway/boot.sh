#!/bin/bash

# Set monitor configuration (initially)
. ~/.config/sway/monitor.sh

if [ $(hostname) = "loki" ]; then
    # Start Barrier server
    . ~/dotfiles/barrier/barriers.sh &

    # Set monitor configuration again, delayed to ensure refresh rate gets set correctly
    # TODO recheck on sway
    #sleep 3 && . ~/.config/sway/monitor.sh &

    # Enable keyboard repeat (better Barrier/Synergy compatibility)
    # TODO recheck on sway
    #xset r on

    # Load OpenRGB profile
    ~/dotfiles/rgb/rgb.sh on
else
    # Power off Bluetooth
    bluetoothctl power off
fi

# Lock on ACPI events (suspend / hibernate / screen blank)
# TODO make work on sway
#xss-lock --transfer-sleep-lock -- ~/.config/sway/lock.sh &

# Prepare workspaces TODO sway
#if [ $(hostname) = "loki" ]; then
#    swaymsg "workspace 0 ; append_layout ~/.config/sway/workspace-0.json"
#    swaymsg "workspace 1 ; append_layout ~/.config/sway/workspace-1.json"
#    swaymsg "workspace 2 ; append_layout ~/.config/sway/workspace-2.json"
#elif [ $(hostname) = "odin" ]; then
#    swaymsg "workspace 1 ; append_layout ~/.config/sway/workspace-1-odin.json"
#fi

# Auto-start programs
$TERMINAL --title "Terminal: htop" htop &
$TERMINAL --title 'Terminal: VM' &

if [ $(hostname) = "loki" ]; then
    firefox &

    $TERMINAL --title "Terminal: sensors" watch -t "sensors zenpower-pci-00c3 -A | grep °C" &
    discord &
    slack &
    chromium &
    #signal-desktop &
    sleep 1 && firefox --new-window about:logo & # allow main firefox to start and take over its window first, as that window will eat whichever comes first

    # Background
    evolution &
    jellyfin-mpv-shim &
    kdeconnect-indicator &
elif [ $(hostname) = "odin" ]; then
    $TERMINAL --title "Terminal: sensors" watch -t "sensors coretemp-isa-0000 -A | grep °C" &
    $TERMINAL &
fi
