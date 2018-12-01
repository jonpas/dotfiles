#!/bin/bash

scrot -q 1 /tmp/screenshot.jpg
if [ $(hostname) = "odin" ]; then
    convert /tmp/screenshot.jpg -resize 80x45 -scale 1600x900 /tmp/screenshotblur.png
else
    convert /tmp/screenshot.jpg -resize 200x130 -scale 3600x1080 /tmp/screenshotblur.png
fi
i3lock -i /tmp/screenshotblur.png
