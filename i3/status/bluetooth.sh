#!/bin/bash

bt=$(rofi-bluetooth --status)

state="Good"
if [[ "${bt:0:2}" == "" ]]; then
    state="Idle"
fi

echo {\"icon\": \"bluetooth\", \"state\": \"$state\"}
