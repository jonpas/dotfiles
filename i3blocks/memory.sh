#!/bin/bash

usage=$(free | grep Mem | awk '{print 100 - int($7/$2 * 100)}')

echo " $usage%"

if [ $usage -ge 90 ]; then
    exit 33
fi
