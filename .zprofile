# Start X on tty1 on correct user (not root, eg. during restore)
if [[ -z $DISPLAY ]] && [[ "$(tty)" = "/dev/tty1" ]] && [[ "$(whoami)" = "jonpas" ]]; then
    exec startx
fi
