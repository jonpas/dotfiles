#!/bin/bash

# Ethernet
eth_interface=enp3s0
if [ $(hostname) != "loki" ]; then
    eth_interface=enp0s25
fi

address=$(ip addr show $eth_interface | grep -Po 'inet \K[\d.]+')
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
    exit 0
fi

# Down
echo " down"
echo " down"
echo "#fb4934"
