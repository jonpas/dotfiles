#!/bin/bash

if [ $(hostname) = "loki" ]; then
    exit 0
fi

if [ ! -z "${BLOCK_BUTTON}" ]; then
    rofi-bluetooth -i &
fi

bt=$(rofi-bluetooth --status)

if [[ "${bt:0:2}" == "" ]]; then
    echo $bt
    exit 0
fi

echo $bt
echo $bt
echo "#73bbff"
