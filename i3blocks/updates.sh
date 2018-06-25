#!/bin/bash

updates=$(($(checkupdates | wc -l) + $(trizen -u | wc -l)))
[[ "$updates" = "0" ]] && exit 0

echo " $updates"
echo " $updates"
echo "#fb4934"
