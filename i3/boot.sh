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
. ~/.config/i3/ws0.sh
. ~/.config/i3/ws1.sh
. ~/.config/i3/ws2.sh
