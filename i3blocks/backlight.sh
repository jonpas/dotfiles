#!/bin/bash

sleep 0.1 # Wait for hardware to actually apply values

actual_brightness=$(cat /sys/class/backlight/acpi_video0/actual_brightness)
max_brightness=$(cat /sys/class/backlight/acpi_video0/max_brightness)

brightness=$(($actual_brightness * 100 / $max_brightness))

echo " $brightness%"
