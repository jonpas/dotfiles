#!/bin/bash

if [ $(amixer get Master | tail -c -5 | head -c -2) == "off" ]; then
    echo "0%"
else
    amixer get Master | grep -E -o '[0-9]{1,3}?%' | head -1
fi
