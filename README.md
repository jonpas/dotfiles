dotfiles
========

Dotfiles for Arch Linux with i3, vim, rofi, urxvt...


### Vim Packages:

Location: `.vim/bundle/`

Download all:
```
$ git submodule init
$ git submodule update
```

### Config Locations:

```
~/ && /root/
    - .vim*
    - .Xresources
    - .bashrc
    - .gtkrc-2.0
    - .prompt.py
    - .vimrc
    - .xinitrc
~/.config/
    - dunst*
    - gtk-3.0/*
    - i3*
    - i3blocks*
    - imgur-screenshot!
/etc/
    - fstab(-hostname)
    - modprobe.d/*
    - NetworkManager/*
    - default/*
    - X11/xorg.conf.d/*
    - mkinitcpio.conf (PT-VM)
```
_Notes:
- `*` folder symlinked, `/*` all files in folder symlinked, `!` not symlinked (sensitive information).
- _`(-hostname)` for splitting different files for different machines._
- _`(PT-VM)` for PCI passthrough Virtual Machine setup._
