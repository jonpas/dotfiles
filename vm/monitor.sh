#!/bin/bash

# Send QEMU monitor command to local running QEMU instance via qemu-monitor socket
#
if [[ $# -lt 1 ]]; then
    echo "Usage: monitor.sh COMMAND"
    echo "  COMMAND: system_powerdown, system_reset, ..."
    exit 1
fi

if [ ! -e /run/user/1000/qemu-monitor.sock ]; then
    echo "QEMU Monitor socket not found!"
    exit 1
fi

echo "$1" | socat - unix-connect:/run/user/1000/qemu-monitor.sock | tail --lines=+2 | grep -v '^(qemu)'
