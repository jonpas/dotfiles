#!/bin/bash

if [ -z "$1" ]; then
    value=$(ddcutil --model "PL3466WQ" getvcp 10 --terse | awk '{print $4}')
    if [ "$value" -ge 50 ]; then
        echo "yes"
    fi
else
    value=$1

    ddcutil --model "PL3466WQ" setvcp 10 $value
    ddcutil --model "LG ULTRAWIDE" setvcp 10 $value
    ddcutil --model "PLE2483H" setvcp 10 $(($value-20))
fi
