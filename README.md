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

### Symbolic Links:

```
~/ && /root/
    - .Xresources
    - .bashrc
    - .vimrc
    - .xinitrc
~/.config/
    - i3*
    - i3blocks* 
/etc/
    - NetworkManager/*
    - grub.d/*
```
_Note: `*` folder symlinked, `/*` all files in folder symlinked._
