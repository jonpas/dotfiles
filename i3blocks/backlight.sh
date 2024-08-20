#!/bin/bash

if [ $(hostname) = "loki" ]; then
    exit 0
fi

# Set to minimal 1 due to acpilight in percieved mode unable to increase from too low values
if [ $(xbacklight -get) -lt 1 ]; then
    xbacklight -set 1
fi

brightness=$(xbacklight -get)
echo " $brightness%"
