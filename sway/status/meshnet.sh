#!/bin/bash

state="Idle"

enabled=$(nordvpn settings | grep Meshnet | awk '{print $2}')

if [ "$enabled" != "enabled" ]; then
    state="Critical"
fi

echo {\"icon\": \"net_wired\", \"state\": \"$state\"}
