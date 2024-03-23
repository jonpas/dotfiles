#!/bin/bash

color="#b8bb26"
firewall=""

enabled=$(ag ENABLED /etc/ufw/ufw.conf)
service=$(systemctl status ufw | ag active | awk '{print $2}')

if [ $enabled != "ENABLED=yes" ] || [ $service != "active" ]; then
    firewall+=" down"
    color="#fb4934"
fi

echo "$firewall"
echo "$firewall"
echo $color
