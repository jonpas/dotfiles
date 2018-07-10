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
    - gsimplecal*
    - i3*
    - i3blocks*
    - imgur-screenshot!
    - ranger/*
    - termite*
    - udiskie*
/etc/
    - NetworkManager/*
    - X11/xorg.conf.d/*
    - default/* (~VFIO)
    - grub.d/*
    - modprobe.d/* (~VFIO)
    - fstab(-hostname)
    - mkinitcpio.conf (VFIO)
    - synergy.conf (~VFIO)
None
    - vm (VFIO)
```
_Notes:_
- _`*` folder symlinked, `/*` all files in folder symlinked, `!` copied (sensitive information)._
- _`(-hostname)` for splitting different files for different machines._
- _`(VFIO)` for PCI passthrough Virtual Machine setup (`~` partially for VFIO)._
