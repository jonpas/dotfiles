#!/bin/bash

stat=$(acpi -b | awk '{print $3}')
charge=$(acpi -b | awk '{print $4}' | cut -d % -f 1)

if [ $stat == "Unknown," ]; then
    echo " $charge%"
    exit 0
fi

if [ $charge -ge 80 ]; then
    echo " $charge%"
    exit 0
fi

if [ $charge -ge 60 ]; then
    echo " $charge%"
    exit 0
fi

if [ $charge -ge 40 ]; then
    echo " $charge%"
    exit 0
fi

if [ $charge -ge 20 ]; then
    echo " $charge%"
    exit 0
fi

echo " $charge%"
exit 33
