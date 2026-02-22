#!/bin/bash

sudo -u jonpas DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus notify-send "UPS" "$* [$(date '+%Y-%m-%d %T')]"

# Requires sudoers: nut ALL=(jonpas) NOPASSWD:SETENV: /usr/bin/notify-send
# which also requires `chage -E -1 nut` for sudoers to work for nut user
