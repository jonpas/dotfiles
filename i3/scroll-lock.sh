#!/bin/bash

# Function
notify-send "Unbound!"

# LED (G710)
stat=$(xset -q | grep "LED" | awk '{print $10}')
mask=000004
led=3

if [ $(($mask & $stat)) == 0 ]; then
    xset led $led
else
    xset -led $led
fi
