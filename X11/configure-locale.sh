#!/bin/bash

# Run to setup locale and keymap config files

# Locale saves to:
# - /etc/locale.conf
localectl set-locale LANG=en_US.UTF-8 LC_TIME=en_GB.UTF-8

# Keyboard layout saves to:
# - /etc/X11/xorg.conf.d/00-keyboard.conf
# - /etc/vconsole.conf
localectl set-x11-keymap si "" "" caps:escape
