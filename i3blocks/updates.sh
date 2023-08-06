#!/bin/bash

updates=$( (checkupdates ; yay -Qua) | wc -l)

if [ "$updates" = "0" ]; then
    exit 0
fi

echo " $updates"
echo " $updates"
echo "#fb4934"
