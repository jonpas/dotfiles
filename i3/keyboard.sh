#!/bin/bash

setxkbmap -layout si

# Caps Lock to Escape
xmodmap -e "remove Lock = Caps_Lock"
xmodmap -e "keycode 66 = Escape" # 66 = Caps Lock

# G710 keys
xmodmap -e "keycode 192 = F14" # 192 = G710 'G1' key
xmodmap -e "keycode 193 = F15" # 193 = G710 'G2' key
xmodmap -e "keycode 194 = F16" # 194 = G710 'G3' key
xmodmap -e "keycode 195 = F17" # 195 = G710 'G4' key
#xmodmap -e "keycode 196 = F18" # 196 = G710 'G5' key # F18 writes ~ in terminal, we have it bound to VM Switcher by scan code
xmodmap -e "keycode 128 = F19" # 128 = G710 'G6' key
