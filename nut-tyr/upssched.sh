#!/bin/bash

case $1 in
    restart_driver)
        # Requires sudoers: nut ALL=NOPASSWD: /usr/bin/systemctl restart nut-driver@cyberpower
        # also requires `chage -E -1 nut` for sudoers to work for nut user
        sudo systemctl restart nut-driver@cyberpower
        logger -t upssched-cmd "Restarted UPS driver for: cyberpower"
        ;;
    *)
        logger -t upssched-cmd "Unrecognized command: $1"
        ;;
esac

