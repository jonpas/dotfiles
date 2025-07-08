# Start WM/DE on correct user (notroot, eg. during restore)
if [[ -z $DISPLAY ]] && [[ "$(whoami)" = "jonpas" ]]; then
    echo "no display and jonpas"
    if [[ "$(tty)" = "/dev/tty1" ]]; then
        # i3 on X11
        startx && exit
    elif [[ "$(tty)" = "/dev/tty2" ]] && [[ "$(hostname)" = "odin" ]]; then
        # KDE Plasma on Wayland
        /usr/lib/plasma-dbus-run-session-if-needed /usr/bin/startplasma-wayland && exit
    fi
fi

export TERMINAL=kitty
export EDITOR=vim

# vi-mode
set -o vi

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

alias cleandisk='yay -Sc && paccache -rk1 && sudo trash-empty --all-users'

alias sysinfo='echo "" && fastfetch'
alias weather='curl http://wttr.in/Lenart'
alias vm='sudo ~/dotfiles/vm/win-pci.sh'
alias ptt='sudo python ~/dotfiles/lib/ptt.py'

alias vcam="sudo modprobe v4l2loopback exclusive_caps=1 card_label='OBS Virtual Camera'"
alias vcamrm="sudo modprobe -r v4l2loopback"

alias matlab='matlab -desktop -nosplash -useStartupFolderPref'

# Bind fg for switching between vim and terminal (C-z / C-a) if interactive shell
if [[ "$-" =~ "i" ]]; then
    bind -x '"\C-a":"fg"'
fi

function __update() {
    yay "$@" &&
    pkill -RTMIN+4 i3status-rs
}
alias yay='__update'

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

export PROMPT_COMMAND=__prompt_command
function __prompt_command() {
    export ERR=$?

    PS1="[\[\e[1;32m\]$(whoami)\[\e[0m\]@\[\e[1;36m\]$(hostname)\[\e[0m\]] $ "

    # Window title
    echo -ne "\033]0;$TERMINAL: $(pwd) \007"

    # Python venv/virtualenv
    if [ -n "$VIRTUAL_ENV" ]; then
        PS1="\[\033[1;34m\]($(basename $VIRTUAL_ENV))\[\e[0m\] $PS1"
    fi
}

# Disable dotnet telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

PATH=$PATH:~/.cargo/bin:~/.local/bin

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
