#!/bin/bash

if [ $(hostname) = "loki" ]; then
    exit 0
fi

stat=$(acpi -b | awk '{print $3}')
charge=$(acpi -b | awk '{print $4}' | cut -d % -f 1)

if [[ $stat == "Charging," ]] || [[ $stat == "Full," ]]; then
    echo " $charge%"
    exit 0
fi

remaining=$(acpi -b | awk '{print $5}' | head -c 5)

if [ $charge -ge 80 ]; then
    echo " $charge% ($remaining)"
    exit 0
fi

if [ $charge -ge 60 ]; then
    echo " $charge% ($remaining)"
    exit 0
fi

if [ $charge -ge 40 ]; then
    echo " $charge% ($remaining)"
    exit 0
fi

if [ $charge -ge 20 ]; then
    echo " $charge% ($remaining)"
    exit 0
fi

echo " $charge% ($remaining)"
exit 33
