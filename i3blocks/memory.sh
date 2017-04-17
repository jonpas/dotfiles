#!/bin/bash

usage=$(free | grep Mem | awk '{print int($3/$2 * 100)}')

echo " $usage%"

if [ $usage -ge 80 ]; then
    exit 33
fi
