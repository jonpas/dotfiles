dotfiles
========

Dotfiles for Arch Linux with i3, vim, rofi, termite... and VFIO.

## Programs

### Subrepos

_Using [git-subrepo](https://github.com/ingydotnet/git-subrepo)._

- Programs: `lib/`

### Vim Plugins

_Using [vim-plug](https://github.com/junegunn/vim-plug) in `.vim/plugged`._

- Errors on first run - vim-plug has to be installed (automatic through `.vimrc`).

## Config Locations

```sh
~/ && /root/
    - .vim*
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
    - NetworkManager/conf.d/*
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
    - vconsole.conf
None
    - backup (BAK)
    - barrier (VFIO)
    - lib
    - vm (VFIO)
```
_Notes:_
- _`*` folder symlinked, `/*` all files in folder symlinked, `!` copied (sensitive information)._
- _`(-hostname)` for splitting different files for different machines._
- _`(BAK)` for backup tools._
- _`(VFIO)` for PCI passthrough Virtual Machine setup (`~` for partially VFIO)._
- _`(GPU-Nvidia)` for Nvidia GPUs._
- _`(iGPU-Intel)` for Intel iGPUs._
