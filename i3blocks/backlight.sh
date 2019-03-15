#!/bin/bash

if [ $(hostname) = "loki" ]; then
    exit 0
fi

sleep 0.1 # Wait for hardware to actually apply values

actual_brightness=$(cat /sys/class/backlight/intel_backlight/actual_brightness)
max_brightness=$(cat /sys/class/backlight/intel_backlight/max_brightness)

brightness=$(($actual_brightness * 100 / $max_brightness))

echo " $brightness%"
