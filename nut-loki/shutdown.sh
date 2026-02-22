#!/bin/bash

echo "system_powerdown" | socat - unix-connect:/run/user/1000/qemu-monitor.sock
while pgrep "qemu-system-x86" > /dev/null; do
    sleep 1
done

shutdown now
