#!/bin/bash

setxkbmap -layout si
xmodmap -e "keycode 200 = Scroll_Lock" # 200 = G710 'G6' key
xmodmap -e "add mod3 = Scroll_Lock" # Scroll Lock keyboard light fix (after binds to include them)
