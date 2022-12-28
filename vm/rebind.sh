#!/bin/bash

if [[ $# -lt 2 ]]; then
    echo "Usage: rebind.sh DEV DRIVER [REMOVE_ID]"
    exit 1
fi

dev="$1"
driver="$2"
removeid="$3"
vendor=$(cat /sys/bus/pci/devices/$dev/vendor)
device=$(cat /sys/bus/pci/devices/$dev/device)

# Unbind
if [ -e /sys/bus/pci/devices/$dev/driver ]; then
    echo $dev > /sys/bus/pci/devices/$dev/driver/unbind
fi
if [ "$removeid" = true ]; then
    # Remove ID (required for XHCI rebind)
    echo $vendor $device > /sys/bus/pci/drivers/vfio-pci/remove_id
fi

# Bind
if [ "$driver" = "vfio-pci" ]; then
    echo $vendor $device > /sys/bus/pci/drivers/$driver/new_id
else
    if [ "$driver" = "nvidia" ] && [ ! -e /sys/bus/pci/drivers/nvidia ]; then
        # Special nvidia handling, version 495 nvidia-modprobe does not seem to create system files unless an
        # unbound GPU is available but it does automatically eat the unbound GPU!
        nvidia-modprobe && sleep 5
    else
        echo $dev > /sys/bus/pci/drivers/$driver/bind
    fi
fi
