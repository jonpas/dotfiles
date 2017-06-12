#!/bin/bash

usage=$(mpstat 1 | head -4 | tail -1 | awk '{print int($4+0.5)}')

echo " $usage%"

if [ $usage -ge 80 ]; then
    exit 33
fi
