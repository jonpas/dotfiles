#!/bin/bash

if [ $(hostname) = "loki" ]; then
    vm=$1

    # Change configuration for VM in the center
    if [ "$vm" = "center" ]; then
        links=$(cat $(dirname $0)/barrier-links-center.conf)
        perl -i.bak -0777pe "s/section: links\n(.+?)\nend/$links/s" $(dirname $0)/barrier.conf
    fi

    # Stop if running and start
    if pgrep -x "barriers" > /dev/null; then
        pkill -x "barriers"
    fi

    barriers --no-daemon --config $(dirname $0)/barrier.conf &

    # Wait a bit for it to start and restore configuration
    sleep 1
    if [ "$vm" = "center" ]; then
        rm $(dirname $0)/barrier.conf
        mv $(dirname $0)/barrier.conf.bak $(dirname $0)/barrier.conf
    fi
fi
