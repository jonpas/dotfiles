dotfiles
========

Dotfiles for Arch Linux with i3, vim, rofi, termite... and VFIO.

## Programs

### Submodules

- Programs: `lib/`

```sh
# Download
$ git submodule init
$ git sumbodule update --remote

# Update
$ git submodule update --recursive --remote
```

### Vim Plugins

_Using [vim-plug](https://github.com/junegunn/vim-plug) in `.vim/plugged`._

- Errors on first run - vim-plug has to be installed (automatic through `.vimrc`).

## Config Locations

```sh
~/ && /root/
    - .vim*
    - .Xresources
    - .bashrc
    - .drirc (GPU)
    - .gtkrc-2.0
    - .prompt.py
    - .p10k.zsh
    - .tmux.conf (REMOTE)
    - .urlview
    - .vimrc
    - .xinitrc (~VFIO)
    - .zprofile (no root)
    - .zshrc
~/.config/
    - dunst*
    - gsimplecal*
    - gtk-3.0/*
    - i3* (~VFIO)
    - i3blocks*
    - ranger/*
    - rgb/*.orp (~/.config/OpenRGB)
    - rofi*
    - termite*
    - udiskie*
    - yay*
~/.local/
    - share/applications/*
/etc/
    - NetworkManager/dispatcher.d/*
    - X11/* (VFIO)
    - X11/xorg.conf.d/*
    - bumblebee/* (GPU)
    - default/*(-hostname) (~VFIO)
    - grub.d/*
    - modprobe.d/* (~VFIO)
    - samba/* (~VFIO)
    - udev/rules.d/* (~VFIO)
    - vm/qemu* (VFIO)
    - fstab(-hostname)
    - locale.conf
    - looking-glass.conf (VFIO)
    - mkinitcpio.conf (VFIO)
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
- _`(GPU)` for GPUs._
- _`(REMOTE)` for remote machine work._
