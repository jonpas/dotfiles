#!/bin/sh

echo "Warning: The UPS's battery power is not enough, system will be shutdown soon!" | wall

sudo -u jonpas DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus notify-send "Warning: Utility battery is low. Shutting down!"
