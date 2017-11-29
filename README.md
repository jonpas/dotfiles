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
    - .Xresources
    - .bashrc
    - .gtkrc-2.0
    - .vimrc
    - .xinitrc
~/.config/
    - dunst*
    - gtk-3.0/*
    - i3*
    - i3blocks*
    - imgur-screenshot!
/etc/
    - fstab
    - modprob.d/*
    - NetworkManager/*
```
_Note: `*` folder symlinked, `/*` all files in folder symlinked, `!` not symlinked (sensitive information)._
