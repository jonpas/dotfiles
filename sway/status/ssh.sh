#!/bin/bash

state="Idle"
connections=$(ss | grep ^tcp | awk '$5 ~ /ssh/' | wc -l)

if [ $connections -gt 0 ]; then
    state="Info"
fi

if [ $connections -gt 1 ]; then
    state="Warning"
fi

echo {\"state\": \"$state\", \"text\": \"SSH $connections\"}
