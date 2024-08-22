#!/bin/bash

# Map G710 keys appropriately (barrier can't read XF86 keys)
xmodmap -e "keysym XF86Launch7 = F16"
xmodmap -e "keysym XF86Launch8 = F17"
xmodmap -e "keysym XF86LaunchA = F19"

vm=$1

# Change configuration for VM in the center
if [ "$vm" = "center" ]; then
    links=$(cat ~/dotfiles/barrier/barrier-links-center.conf)
    perl -i.bak -0777pe "s/section: links\n(.+?)\nend/$links/s" ~/dotfiles/barrier/barrier.conf
elif [ "$vm" = "both" ]; then
    links=$(cat ~/dotfiles/barrier/barrier-links-both.conf)
    perl -i.bak -0777pe "s/section: links\n(.+?)\nend/$links/s" ~/dotfiles/barrier/barrier.conf
fi

# Stop if running and start
if pgrep -x "barriers" > /dev/null; then
    pkill -x "barriers"
fi

# SSL seems to be broken at the moment
barriers -f --disable-crypto -c ~/dotfiles/barrier/barrier.conf &>~/.barriers.log &

# Wait a bit for it to start and restore configuration
sleep 1
if [ "$vm" = "center" ] || [ "$vm" = "both" ]; then
    rm ~/dotfiles/barrier/barrier.conf
    mv ~/dotfiles/barrier/barrier.conf.bak ~/dotfiles/barrier/barrier.conf
fi

# Map original keys back
# Takes effect as soon as barriers is shut down
xmodmap -e "keysym F16 = XF86Launch7"
xmodmap -e "keysym F17 = XF86Launch8"
xmodmap -e "keysym F19 = XF86LaunchA"
