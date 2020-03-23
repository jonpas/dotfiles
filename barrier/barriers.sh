#!/bin/bash

if [ $(hostname) = "loki" ]; then
    vm=$1

    # Change configuration for VM in the center
    if [ "$vm" = "center" ]; then
        links=$(cat ~/dotfiles/barrier/barrier-links-center.conf)
        perl -i.bak -0777pe "s/section: links\n(.+?)\nend/$links/s" ~/dotfiles/barrier/barrier.conf
    elif [ "$vm" = "both" ]; then
        links=$(cat ~/dotfiles/barrier/barrier-links-both.conf)
        perl -i.bak -0777pe "s/section: links\n(.+?)\nend/$links/s" ~/dotfiles/barrier/barrier.conf
    fi

    # Stop if running and start
    if pgrep -x "barriers" > /dev/null; then
        pkill -x "barriers"
    fi

    barriers -f -c ~/dotfiles/barrier/barrier.conf &>~/.barriers.log &

    # Wait a bit for it to start and restore configuration
    sleep 1
    if [ "$vm" = "center" ] || [ "$vm" = "both" ]; then
        rm ~/dotfiles/barrier/barrier.conf
        mv ~/dotfiles/barrier/barrier.conf.bak ~/dotfiles/barrier/barrier.conf
    fi
fi
