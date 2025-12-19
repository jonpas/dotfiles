# Start WM/DE on correct user (not root, eg. during restore, only on loki as odin uses SDDM)
if [[ -z $DISPLAY ]] && [[ "$(hostname)" = "loki" ]] && [[ "$(whoami)" = "jonpas" ]] && [[ "$(tty)" = "/dev/tty1" ]]; then
    # i3 on X11
    exec startx && exit

    # KDE Plasma on Wayland
    #/usr/lib/plasma-dbus-run-session-if-needed /usr/bin/startplasma-wayland && exit
fi
