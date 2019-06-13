#!/bin/bash

updates=$(($(yay -Qu | wc -l)))

if [ "$updates" = "0" ]; then
    exit 0
fi

echo " $updates"
echo " $updates"
echo "#fb4934"
