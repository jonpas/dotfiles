#!/bin/bash

usage=$(mpstat 1 1 | awk '/^Average/ {print int(100-$NF)}')

echo " $usage%"

if [ $usage -ge 80 ]; then
    exit 33
fi
