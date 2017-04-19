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
/home/jonpas/ && /root/
    - .Xresources
    - .bashrc
    - .vimrc
    - .xinitrc
/etc/
    - NetworkManager/*
    - grub.d/*
~/.config/
    - i3*
    - i3blocks* 
```
_Note: `*` folder symlinked, `/*` all files in folder symlinked_
