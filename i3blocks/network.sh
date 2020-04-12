#!/bin/bash

wired_interfaces=(bridge0 enp3s0)
wirless_interfaces=()

if [ $(hostname) != "loki" ]; then
    wired_interfaces=(enp0s25)
    wireless_interfaces=(wlp3s0)
fi

# Wired
for interface in $wired_interfaces; do
    address=$(ip addr show $interface | grep -Po 'inet \K[\d.]+')
    if [ -n "$address" ]; then
        echo " $address"
        echo " $address"
        echo "#b8bb26"
        exit 0
    fi
done

# Wi-Fi
for interface in $wireless_interfaces; do
    address=$(ip addr show $interface | grep -Po 'inet \K[\d.]+')
    if [ -n "$address" ]; then
        ssid=$(iwconfig | grep -o ESSID.* | tail -c +8 | head -c -4)
        echo " $address ($ssid)"
        echo " $ssid"
        echo "#b8bb26"
        exit 0
    fi
done

# Down
echo " down"
echo " down"
echo "#fb4934"
