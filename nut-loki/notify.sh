#!/bin/bash

sudo -u jonpas DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus notify-send "UPS" "$* [$(date '+%Y-%m-%d %T')]"

# Requires sudoers lines below and `chage -E -1 nut` for sudoers to work for nut user
#   Defaults!/usr/bin/notify-send env_keep += "DBUS_SESSION_BUS_ADDRESS"
#   nut ALL=(jonpas) NOPASSWD: /usr/bin/notify-send
