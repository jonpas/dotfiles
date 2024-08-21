#!/bin/bash

state="Good"

enabled=$(ag ENABLED /etc/ufw/ufw.conf)
service=$(systemctl status ufw | ag active | awk '{print $2}')

if [ $enabled != "ENABLED=yes" ] || [ $service != "active" ]; then
    state="Critical"
fi

echo {\"icon\": \"firewall\", \"state\": \"$state\"}
