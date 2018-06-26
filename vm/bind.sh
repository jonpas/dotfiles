#!/bin/bash

configfile=vfio-pci.cfg

vfiobind() {
    dev="$1"
    vendor=$(cat /sys/bus/pci/devices/$dev/vendor)
    device=$(cat /sys/bus/pci/devices/$dev/device)
    if [ -e /sys/bus/pci/devices/$dev/driver ]; then
        echo $dev > /sys/bus/pci/devices/$dev/driver/unbind
    fi
    echo $vendor $device > /sys/bus/pci/drivers/vfio-pci/new_id
}

cat $configfile | while read line;do
    echo $line | grep ^\# >/dev/null 2>&1 && continue
    vfiobind $line
done
