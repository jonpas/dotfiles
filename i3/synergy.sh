#!/bin/bash

if [ $(hostname) = "loki" ]; then
    vm=$1

    # Change Synergy configuration for VM in the center
    if [ "$vm" = "center" ]; then
        config_vm_center=$(cat ~/dotfiles/synergy-vm-center.conf)
        perl -i.bak -0777pe "s/section: links\n(.+?)\nend/$config_vm_center/s" ~/dotfiles/synergy.conf
    fi

    pkill -x synergys
    synergys -d WARNING # No SSL due to connection issues

    # Restore Synergy configuration
    if [ "$vm" = "center" ]; then
        rm ~/dotfiles/synergy.conf
        mv ~/dotfiles/synergy.conf.bak ~/dotfiles/synergy.conf
    fi
fi
