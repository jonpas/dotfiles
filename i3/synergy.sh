#!/bin/bash

if [ $(hostname) = "loki" ]; then
    pkill -x synergys
    synergys -d WARNING # No SSL due to connection issues
fi
