#!/bin/bash

address=$(ip addr | grep -o '192\..*\..*\..*/' | head -c -2)

if [ $(iwconfig | grep -o ESSID.*) != "ESSID:off/any" ]; then
    # Wi-Fi
    ssid=$(iwconfig | grep -o ESSID.* | tail -c +8 | head -c -4)

    echo " $address ($ssid)"
    echo " $ssid"
    echo "#b8bb26"
elif [ $(cat /sys/class/net/enp0s25/operstate) == "up" ]; then
    # Ethernet
    echo " $address"
    echo " $address"
    echo "#b8bb26"
else
    # Down
    echo " down"
    echo " down"
    echo "#fb4934"
fi
