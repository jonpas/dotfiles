#!/bin/bash

if [[ $# -lt 2 ]]; then
    echo "Usage: rebind.sh DEV DRIVER"
    exit 1
fi

dev="$1"
driver="$2"

# vfio-pci does not handle ID assignment itself
vendor=$(cat /sys/bus/pci/devices/$dev/vendor)
device=$(cat /sys/bus/pci/devices/$dev/device)

# Unbind
if [ -e /sys/bus/pci/devices/$dev/driver ]; then
    driver_unbind=$(basename $(readlink /sys/bus/pci/devices/$dev/driver))
    if [ "$driver_unbind" = "vfio-pci" ]; then
        echo $vendor $device > /sys/bus/pci/drivers/vfio-pci/remove_id
    fi

    echo $dev > /sys/bus/pci/devices/$dev/driver/unbind
fi

# Bind
if [ "$driver" = "none" ]; then
    exit 0
elif [ "$driver" = "vfio-pci" ]; then
    echo $vendor $device > /sys/bus/pci/drivers/vfio-pci/new_id
elif [ "$driver" = "nvidia" ] && [ ! -e /sys/bus/pci/drivers/nvidia ]; then
    # Special nvidia handling, version 495 nvidia-modprobe does not seem to create system files unless an
    # unbound GPU is available but it does automatically eat the unbound GPU!
    nvidia-modprobe && sleep 5
else
    echo $dev > /sys/bus/pci/drivers/$driver/bind
fi
