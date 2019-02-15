dotfiles
========

Dotfiles for Arch Linux with i3, vim, rofi, alacritty... and VFIO.


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
    - ranger/*
    - termite* (unused)
    - alacritty*
    - udiskie*
/etc/
    - NetworkManager/dispatcher.d/*
    - X11/* (VFIO)
    - X11/xorg.conf.d/*
    - default/* (~VFIO)
    - grub.d/*
    - modprobe.d/*
    - pacman.d/hooks* (Nvidia)
    - samba/* (~VFIO)
    - fstab(-hostname)
    - locale.conf
    - mkinitcpio.conf (VFIO)
    - slim.conf
    - synergy.conf (~VFIO)
    - vconsole.conf
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
- _`(Nvidia)` for Nvidia GPUs._
