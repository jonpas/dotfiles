#!/bin/bash

setxkbmap -layout si
xmodmap -e "keycode 128 = Scroll_Lock" # 128 = G710 'G6' key
xmodmap -e "add mod3 = Scroll_Lock" # Scroll Lock keyboard light fix (after binds to include them)
