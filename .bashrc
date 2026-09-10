# Start WM/DE on correct user (not root, eg. during restore, only on loki as odin uses SDDM)
if [[ -z $DISPLAY ]] && [[ "$(hostname)" = "loki" ]] && [[ "$(whoami)" = "jonpas" ]] && [["$(tty)" = "/dev/tty1" ]]; then
    # i3 on X11
    startx && exit

    # KDE Plasma on Wayland
    #/usr/lib/plasma-dbus-run-session-if-needed /usr/bin/startplasma-wayland && exit
fi

HISTSIZE=10000000
HISTFILESIZE=10000000

export TERMINAL=kitty
export EDITOR=vim

if [[ $- == *i* ]]; then
    source /usr/share/blesh/ble.sh --attach=none
    eval "$(starship init bash)"

    # vi-mode
    set -o vi

    # Bind fg for switching between vim and terminal (C-z / C-a)
    bind -x '"\C-a":"fg"'
fi

alias sudo='sudo ' # check 2nd word for alias as well

alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ll='ls -alhFv --color=auto --group-directories-first'
alias la='ls -Av'
alias l='ls -CFv'

alias fd='fd --hidden'
alias bc='bc -lq'

alias ssh='TERM=vt100 ssh' # kitty terminfo is different, use vt100 for SSH for maximum compatibility
alias kssh='kitten ssh' # makes use of TERM=xterm-kitty and automatically copies terminfo files
alias rsyncnoperm="rsync -azPZ"

alias cleandisk='yay -Sc && paccache -rk1 && sudo trash-empty --all-users'

alias sysinfo='echo "" && fastfetch'
alias weather='curl http://wttr.in/Lenart'
alias vm='sudo ~/dotfiles/vm/win-pci.sh'

alias vcam="sudo modprobe v4l2loopback exclusive_caps=1 card_label='OBS Virtual Camera'"
alias vcamrm="sudo modprobe -r v4l2loopback"

alias matlab='matlab -desktop -nosplash -useStartupFolderPref'

function set_win_title() {
    echo -ne "\033];$TERMINAL: $(pwd) \007"
}
starship_precmd_user_func="set_win_title"

function setname() {
    i3-msg title_format "$@"
}
function setnamep() {
    i3-msg focus parent, title_format "$@", focus child
}

function __update() {
    yay "$@" &&
    pkill -RTMIN+4 i3status-rs
}
alias yay='__update'

function __dri_prime() {
    DRI_PRIME=1 "$@" # PRIME
}
alias gpu='__dri_prime'
alias obs='vk_pro obs'

function __vnc_server() {
    display=3 # default 1080p display
    if [ ! -z "$1" ]; then
        display=$1
    fi

    displays=(
        3440x1440+0+795
        2560x1080+3440+1080
        1920x1080+3440+0)
    echo "Starting x1vnc with -clip ${displays[display]}"
    x11vnc -display :0 -localhost -clip ${displays[display]}
}
alias vnc='__vnc_server'

# Require virtualenv for pip
export PIP_REQUIRE_VIRTUALENV=true
function __pip_global() {
    PIP_REQUIRE_VIRTUALENV=false pip "$@"
}
alias pip-global='__pip_global'

function __unlock_keyring() {
    read -rs "pass?Password: "
    export $(echo -n "$pass" | gnome-keyring-daemon --replace --unlock)
    unset pass
}
alias unlock-keyring='__unlock_keyring'

export FZF_DEFAULT_COMMAND='fd --hidden --follow --exclude ".git"' # use with fd instead of find

if [ -f /usr/share/bash-completion/completions/git ]; then
    . /usr/share/bash-completion/completions/git
fi

if [ -f /usr/share/bash-completion/completions/gh ]; then
    . /usr/share/bash-completion/completions/gh
fi

if [ -f /usr/share/nvm/init-nvm.sh ]; then
    # init-vm.sh is slow, only init on request
    alias nvminit='. /usr/share/nvm/init-nvm.sh'
fi

# Disable dotnet telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

[ -d "$HOME/.cargo/bin" ] && PATH=$PATH:$HOME/.cargo/bin
PATH=$PATH:~/.local/bin

# Jump to path and synchronization aliases
__base_school='~/Work/School/FERI-RIT'

alias jL='cd ~/Work/Linux'
alias jS="cd $__base_school"
alias jSP="cd $__base_school/Projects/MAG"
alias jSF="cd $__base_school/Theses/MAG"
alias jA3='cd ~/Work/Arma\ 3'
alias jA3M='cd ~/Work/Arma\ 3/Mods'
alias jA3T='cd ~/Work/Arma\ 3/Tools'
alias jIDI='cd ~/Work/IDI'

if [ $(hostname) = "odin" ]; then
    alias vm='sudo ~/dotfiles/vm/win-gvt.sh'
fi

[[ ${BLE_VERSION-} ]] && ble-attach
