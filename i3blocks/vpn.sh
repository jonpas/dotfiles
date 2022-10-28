#!/bin/bash

color="#b8bb26"
vpn=""

vpnstatus=$(nordvpn status | grep Status | awk '{print $3}')

if [ $vpnstatus != "Connected" ]; then
    vpn=""

    if [ $(hostname) != "loki" ]; then
        color="#fb4934"
    fi
fi

echo "$vpn"
echo "$vpn"
echo $color
