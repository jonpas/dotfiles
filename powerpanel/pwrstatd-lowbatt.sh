#!/bin/sh

echo "Warning: UPS battery power is low. Shutting down!" | wall

sudo -u jonpas DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus notify-send "Warning: UPS battery is low. Shutting down!"
