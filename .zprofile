# Start WM/DE on correct user (not root, eg. during restore)
if [[ -z $DISPLAY ]] && [[ "$(whoami)" = "jonpas" ]]; then
    if [[ "$(tty)" = "/dev/tty1" ]]; then
        # i3 on X11
        exec startx && exit
    elif [[ "$(tty)" = "/dev/tty2" ]] && [[ "$(hostname)" = "odin" ]]; then
        # KDE Plasma on Wayland
        /usr/lib/plasma-dbus-run-session-if-needed /usr/bin/startplasma-wayland && exit
    elif [[ "$(tty)" = "/dev/tty3" ]]; then
        # Sway on Wayland
        exec sway && exit
    fi
fi
