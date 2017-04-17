#!/bin/bash

scrot -q 1 /tmp/screenshot.jpg
convert /tmp/screenshot.jpg -resize 77x45 -scale 1440x900 /tmp/screenshotblur.png
i3lock -i /tmp/screenshotblur.png
