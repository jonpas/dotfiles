#!/bin/bash

# Ethernet
address=$(ip addr show enp0s25 | grep -Po 'inet \K[\d.]+')
if [ -n "$address" ]; then
    echo " $address"
    echo " $address"
    echo "#b8bb26"
    exit 0
fi

# Wi-Fi
address=$(ip addr show wlp3s0 | grep -Po 'inet \K[\d.]+')
if [ -n "$address" ]; then
    ssid=$(iwconfig | grep -o ESSID.* | tail -c +8 | head -c -4)
    echo " $address ($ssid)"
    echo " $ssid"
    echo "#b8bb26"
    echo 0
fi

# Down
echo " down"
echo " down"
echo "#fb4934"
