#!/bin/bash

if [[ $# -lt 2 ]]; then
    echo "Usage: mdev.sh PCI GUID [TYPE]"
    exit 1
fi

pci="$1"
guid="$2"
mtype="$3"

if [ -z "$mtype" ]; then
    if [ -e /sys/devices/pci0000:00/$pci/$guid/remove ]; then
        echo 1 > /sys/devices/pci0000:00/$pci/$guid/remove
    else
        echo "mdev $pci/$guid does not exist"
    fi
elif [ -e /sys/devices/pci0000:00/$pci/mdev_supported_types/$mtype/create ]; then
    if [ -e /sys/bus/mdev/devices/$guid ]; then
        echo "mdev $guid$ already exists"
    else
        echo $guid > /sys/devices/pci0000:00/$pci/mdev_supported_types/$mtype/create
    fi
else
    echo "mdev type $pci/$mtype not supported"
fi
