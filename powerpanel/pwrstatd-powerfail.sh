#!/bin/sh

echo "Warning: Utility power has failed. Now running on battery." | wall

sudo -u jonpas ssh loki "echo \"Warning: Utility power has failed. Now running on battery.\" | wall"
sudo -u jonpas ssh loki "DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus notify-send \"Warning: Utility power has failed. Now running on battery. [$(date '+%Y-%m-%d %T')]\""
