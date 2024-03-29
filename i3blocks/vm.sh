#!/bin/bash

if [ $(hostname) != "loki" ]; then
    exit 0
fi

sleep 1 # Wait for signalling process a bit

vm=" "
gpu=" "
color="#a9a9a9"

# Win VM
if pgrep "win-pci" > /dev/null; then
    vm+=" "
    color="#d3d3d3"
else
    vm+=" "
fi

# GPU Pass-Through
gpu_drv=$(lspci -s 0c:00.0 -k | awk -F': ' '/Kernel driver in use/{print tolower($2)}')
aud_drv=$(lspci -s 0c:00.1 -k | awk -F': ' '/Kernel driver in use/{print tolower($2)}')

if [ "$gpu_drv" == "vfio-pci" ] && [ "$aud_drv" == "vfio-pci" ]; then
    gpu+="VFIO"
    color="#d3d3d3"
elif [[ ("$gpu_drv" == "nvidia" || "$gpu_drv" == "nouveau" || "$gpu_drv" == "amdgpu") && "$aud_drv" == "snd_hda_intel" ]]; then
    gpu+="HOST"
else
    gpu+="NONE"
    color="#fb4934"
fi

# Barrier (Scroll Lock LED as locked to screen indicator)
last_state_log=$(cat ~/.barriers.log | grep -a "locked" | tail -n 1)
if grep --quiet " locked" <<< $last_state_log; then
    xset led named "Scroll Lock"
else
    xset -led named "Scroll Lock"
fi

echo "$vm $gpu"
echo "$vm $gpu"
echo $color
