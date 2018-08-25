dotfiles
========

Dotfiles for Arch Linux with i3, vim, rofi, termite...


### Program Packages/Plugins/Scripts:

- Vim: `.vim/bundle/`
- WeeChat: `.weechat/python/autoload/` (scripts symlinked from submodules)

Download all:
```
$ git submodule init
$ git submodule update
```

Update all:
```
$ git submodule update --recursive --remote
```


### Config Locations:

```
~/ && /root/
    - .vim*
    - .weechat/*
    - .Xresources
    - .bashrc
    - .gtkrc-2.0
    - .prompt.py
    - .vimrc
    - .xinitrc (~VFIO)
~/.config/
    - dunst*
    - gsimplecal*
    - gtk-3.0/*
    - i3* (~VFIO)
    - i3blocks*
    - imgur-screenshot!
    - pacman.d/hooks*
    - ranger/*
    - termite*
    - udiskie*
/etc/
    - NetworkManager/*
    - X11/* (~VFIO)
    - X11/xorg.conf.d/*
    - default/* (~VFIO)
    - grub.d/*
    - modprobe.d/* (~VFIO)
    - samba/* (~VFIO)
    - fstab(-hostname)
    - mkinitcpio.conf (VFIO)
    - slim.conf
    - synergy.conf (~VFIO)
None
    - backup (BAK)
    - vm (VFIO)
    - synergy-vm-center.conf (VFIO)
```
_Notes:_
- _`*` folder symlinked, `/*` all files in folder symlinked, `!` copied (sensitive information)._
- _`(-hostname)` for splitting different files for different machines._
- _`(BAK)` for backup tools._
- _`(VFIO)` for PCI passthrough Virtual Machine setup (`~` for partially VFIO)._
