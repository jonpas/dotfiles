#!/bin/bash

usage=$(mpstat 1 1 | awk '$13 ~ /[0-9.]+/ {print int(100-$13)}')

echo " $usage%"

if [ $usage -ge 80 ]; then
    exit 33
fi
