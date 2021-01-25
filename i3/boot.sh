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

## Workspace 0 (system / VM)
#i3-msg "workspace 0  ; append_layout ~/.config/i3/workspace-0.json"
#
#i3-sensible-terminal -e htop -t "Terminal: htop" &
#
#if [ $(hostname) = "loki" ]; then
#    i3-sensible-terminal -e 'watch -t "sensors zenpower-pci-00c3 -A | grep °C"' -t "Terminal: sensors" &
#else
#    i3-sensible-terminal -e 'watch -t "sensors coretemp-isa-0000 -A | grep °C"' -t "Terminal: sensors" &
#fi
#
#i3-sensible-terminal -t 'Terminal: WinVM' &
#
#firefox --new-window about:logo &
#
## Workspace 1 (chat)
#i3-msg "workspace 1  ; append_layout ~/.config/i3/workspace-1.json"
#
#slack &
#discord &
#chromium &
#
## Workspace 2 (main)
#i3-msg "workspace 2  ; append_layout ~/.config/i3/workspace-2.json"
#
#firefox &

# TEST
i3-msg "workspace 0  ; append_layout ~/.config/i3/workspace-0.json"
i3-msg "workspace 1  ; append_layout ~/.config/i3/workspace-1.json"
i3-msg "workspace 2  ; append_layout ~/.config/i3/workspace-2.json"

i3-sensible-terminal -e htop -t "Terminal: htop" &
i3-sensible-terminal -t 'Terminal: VM' &

if [ $(hostname) = "loki" ]; then
    i3-sensible-terminal -e 'watch -t "sensors zenpower-pci-00c3 -A | grep °C"' -t "Terminal: sensors" &
else
    i3-sensible-terminal -e 'watch -t "sensors coretemp-isa-0000 -A | grep °C"' -t "Terminal: sensors" &
fi

slack &
discord &
chromium &
firefox &
firefox --new-window about:logo &
