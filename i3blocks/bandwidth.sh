#!/bin/bash
# Copyright (C) 2012 Stefan Breunig <stefan+measure-net-speed@mathphys.fsk.uni-heidelberg.de>
# Copyright (C) 2014 kaueraal
# Copyright (C) 2015 Thiago Perrotta <perrotta dot thiago at poli dot ufrj dot br>
# Copyright (C) 2019 Jonpas

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Use the devices used for the default route and check which one is up
interfaces=$(ip route | awk '/^default/ {print $5}')
interface=""

for intf in $interfaces; do
    if [ -e "/sys/class/net/${intf}/operstate" ] && [ $(cat /sys/class/net/${intf}/operstate) = "up" ]; then
        interface=$intf
        break
    fi
done

# No connection
if [ -z "$interface" ]; then
    echo "     "
    echo "     "
    echo "#fb4934"
    exit 0
fi

# Path to store the old results in
path="/dev/shm/$(basename $0)-${interface}"

# Grab data for each adapter
read rx < "/sys/class/net/${interface}/statistics/rx_bytes"
read tx < "/sys/class/net/${interface}/statistics/tx_bytes"

# Get time
time=$(date +%s)

# Write current data if file does not exist
# Do not exit, would cause problems if this file is
# sourced instead of executed as another process
if ! [ -f "${path}" ]; then
    echo "${time} ${rx} ${tx}" > "${path}"
    chmod 0666 "${path}"
fi

# Read previous state and update data storage
read old < "${path}"
echo "${time} ${rx} ${tx}" > "${path}"

# Parse old data and calculate time passed
old=(${old//;/ })
time_diff=$(( $time - ${old[0]} ))

# Calculate bytes transferred, and their rate in byte/s
rx_diff=$(( $rx - ${old[1]} ))
tx_diff=$(( $tx - ${old[2]} ))
rx_rate=$(( $rx_diff / $time_diff ))
tx_rate=$(( $tx_diff / $time_diff ))

# Shift by 10 bytes to get KiB/s
# If the value is larger than 1024^2 = 1048576, display MiB/s instead

# Incoming
rx_bw=$(( $rx_rate >> 10 ))K
if hash bc 2>/dev/null && [[ "$rx_rate" -gt 1048576 ]]; then
    printf -v rx_bw "%sM" $(echo "scale=1; $rx_bw / 1024" | bc)
fi

# Outgoing
tx_bw=$(( $tx_rate >> 10 ))K
if hash bc 2>/dev/null && [[ "$tx_rate" -gt 1048576 ]]; then
    printf -v tx_bw "%sM" $(echo "scale=1; $tx_bw / 1024" | bc)
fi

echo " ${rx_bw}  ${tx_bw}"
echo " ${rx_bw}  ${tx_bw}"
