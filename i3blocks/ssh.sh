#!/bin/bash

if [ $(hostname) != "loki" ]; then
    exit 0
fi

if [ ! -z "${BLOCK_BUTTON}" ]; then
    notify-send "Active SSH Connections" "$(ss | grep ^tcp | awk '$5 ~ /ssh/ {print $6}')" &
fi

connections=$(ss | grep ^tcp | awk '$5 ~ /ssh/' | wc -l)

ssh=""
color="#b8bb26"

if [ $connections -gt 0 ]; then
    ssh=""
    color=""
fi

if [ $connections -gt 1 ]; then
    color="#fb4934"
fi

echo "$ssh $connections"
echo "$ssh $connections"
echo $color
