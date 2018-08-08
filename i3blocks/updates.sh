#!/bin/bash

updates=$(yay -Pu | wc -l)
[[ "$updates" = "0" ]] && exit 0

echo " $updates"
echo " $updates"
echo "#fb4934"
