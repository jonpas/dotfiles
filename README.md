dotfiles
========

Dotfiles for Arch Linux with i3, vim, rofi, termite... and VFIO.


### Programs/Packages/Plugins/Scripts:

- Programs: `lib/`
- Vim: `.vim/bundle/`
- WeeChat: `.weechat/python/autoload/` (scripts symlinked from submodules)

Download all:
```
$ git submodule init
$ git submodule update --remote
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
    - .drirc (iGPU-Intel)
    - .gtkrc-2.0
    - .prompt.py
    - .vimrc
    - .xinitrc (~VFIO)
~/.config/
    - alacritty* (unused - https://github.com/tomaka/winit/issues/705)
    - dunst*
    - gsimplecal*
    - gtk-3.0/*
    - i3* (~VFIO)
    - i3blocks*
    - ranger/*
    - termite*
    - udiskie*
    - yay*
/etc/
    - NetworkManager/dispatcher.d/*
    - X11/* (VFIO)
    - X11/xorg.conf.d/*
    - default/* (~VFIO)
    - grub.d/*
    - modprobe.d/*
    - pacman.d/hooks* (GPU-Nvidia)
    - samba/* (~VFIO)
    - fstab(-hostname)
    - locale.conf
    - looking-glass.conf (VFIO)
    - mkinitcpio.conf (VFIO)
    - slim.conf
    - synergy.conf (~VFIO)
    - vconsole.conf
None
    - backup (BAK)
    - lib
    - vm (VFIO)
    - synergy-vm-center.conf (VFIO)
```
_Notes:_
- _`*` folder symlinked, `/*` all files in folder symlinked, `!` copied (sensitive information)._
- _`(-hostname)` for splitting different files for different machines._
- _`(BAK)` for backup tools._
- _`(VFIO)` for PCI passthrough Virtual Machine setup (`~` for partially VFIO)._
- _`(GPU-Nvidia)` for Nvidia GPUs._
- _`(iGPU-Intel)` for Intel iGPUs._
