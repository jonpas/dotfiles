#!/bin/bash

if [ $(hostname) != "loki" ]; then
    exit 0
fi

vm="  "
gpu=" HOST"
color="#a9a9a9"

if [ $(pgrep "win10-pci") ]; then
    vm="  "
    color="#d3d3d3"
fi

gpu_drv=$(lspci -s 01:00.0 -k | awk -F': ' '/Kernel driver in use/{print tolower($2)}')
aud_drv=$(lspci -s 01:00.1 -k | awk -F': ' '/Kernel driver in use/{print tolower($2)}')

if [ "$gpu_drv" == "vfio-pci" ] && [ "$aud_drv" == "vfio-pci" ]; then
    gpu=" VFIO"
    color="#d3d3d3"
elif [ "$gpu_drv" != "nvidia" ] || [ "$aud_drv" != "snd_hda_intel" ]; then
    gpu=" NONE"
    color="#fb4934"
fi

echo "$vm $gpu"
echo "$vm $gpu"
echo $color
