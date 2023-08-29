#!/bin/sh

echo "Warning: Utility power failure has occurred for a while, system will be shutdown soon!" | wall

sudo -u jonpas DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus notify-send "Warning: Utility power has failed. Now running on battery."
