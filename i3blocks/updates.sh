#!/bin/bash

$(yay -Syq)  # Sync package databases
updates=$(($(yay -Pn)))  # Get number of updates

if [ "$updates" = "0" ]; then
    exit 0
fi

echo " $updates"
echo " $updates"
echo "#fb4934"
