#!/bin/bash

if [ $(hostname) = "loki" ]; then
    echo ""
    echo ""
    echo ""
    exit 1
fi

if [ $(hostname) = "ancient" ]; then
    class=acpi_video0
else
    class=intel_backlight
fi

sleep 0.1 # Wait for hardware to actually apply values

actual_brightness=$(cat /sys/class/backlight/$class/actual_brightness)
max_brightness=$(cat /sys/class/backlight/$class/max_brightness)

brightness=$(($actual_brightness * 100 / $max_brightness))

echo " $brightness%"
