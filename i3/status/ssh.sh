#!/bin/bash

state="Good"
connections=$(ss | grep ^tcp | awk '$5 ~ /ssh/' | wc -l)

if [ $connections -gt 0 ]; then
    state="Warning"
fi

if [ $connections -gt 1 ]; then
    state="Critical"
fi

echo {\"state\": \"$state\", \"text\": \"SSH $connections\"}
