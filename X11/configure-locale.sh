#!/bin/bash

# Run to setup locale and keymap config files

# Locale saves to:
# - /etc/locale.conf
localectl set-locale LANG=en_US.UTF-8 LC_TIME=en_GB.UTF-8

# Keyboard layout saves to:
# - /etc/X11/xorg.conf.d/00-keyboard.conf
# - /etc/vconsole.conf
localectl set-x11-keymap si "" "" caps:escape

# G710 keys - set by xkb: /usr/share/X11/xkb/symbols/inet
# keycode 192 = XF86Launch5
# keycode 193 = XF86Launch6
# keycode 194 = XF86Launch7
# keycode 195 = XF86Launch8
# keycode 196 = XF86Launch9
# keycode 128 = XF86LaunchA
