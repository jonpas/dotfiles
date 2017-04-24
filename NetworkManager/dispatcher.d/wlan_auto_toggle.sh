#!/bin/bash
# Must be owned by root!

if [[ "$1" == "enp0s25" ]] && [[ "$2" == "up" ]] ; then
    nmcli radio wifi off
elif [ $(nmcli radio wifi) == "disabled" ]; then
    nmcli radio wifi on
fi
