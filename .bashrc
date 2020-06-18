if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    startx && exit
fi

export TERMINAL=termite #alacritty https://github.com/tomaka/winit/issues/705
export EDITOR=vim

alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ll='ls -alhFv --color=auto --group-directories-first'
alias la='ls -Av'
alias l='ls -CFv'

alias fd="fd --hidden"

alias rm='rmtrash'
alias rmdir='rmdirtrash'

alias sysinfo='echo "" && neofetch'
alias weather='curl http://wttr.in/Lenart'
alias vm='sudo ~/dotfiles/vm/win10-pci.sh'

alias cleandisk="yay -Sc && paccache -rk1"
alias vcam="sudo modprobe v4l2loopback exclusive_caps=1"
alias vcamrm="sudo modprobe -r v4l2loopback"

# If interactive shell
if [[ "$-" =~ "i" ]]; then
    # Bind fg for switching between vim and terminal (C-z / C-a)
    bind -x '"\C-a":"fg"'
fi

function __update() {
    yay "$@" &&
    pkill -RTMIN+4 i3blocks
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

    # Presentational (shorter) prompt
    if [ -n "$PRESENT_PROMPT" ]; then
        USER="uni"
    fi

    if [ -x "$(command -v prompt-rs)" ]; then
        prompt-rs --right
        PS1=$(prompt-rs --left)
    else
        PS1="[\[\e[1;32m\]$(whoami)\[\e[0m\]@\[\e[1;36m\]$(hostname)\[\e[0m\]] $ "
    fi

    # Window title
    echo -ne "\033]0;$TERMINAL: $(pwd) \007"

    # Python venv/virtualenv
    if [ -n "$VIRTUAL_ENV" ]; then
        PS1="\[\033[1;34m\]($(basename $VIRTUAL_ENV))\[\e[0m\] $PS1"
    fi
}

# Disable dotnet telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

PATH=$PATH:~/.cargo/bin

# Jump to path aliases
alias jL='cd ~/Work/Linux'
alias jS='cd ~/Work/School/FERI-RIT'
alias jST='cd ~/Work/School/FERI-RIT/Tasks/MAG-1-2'
alias jSD='cd ~/Work/School/FERI-RIT/Data/MAG-1-2'
alias jSP='cd ~/Work/School/FERI-RIT/Projects/MAG'
alias jSF='cd ~/Work/School/FERI-RIT/Theses/MAG'
alias jA3='cd ~/Work/Arma\ 3'
alias jA3M='cd ~/Work/Arma\ 3/Mods'
alias jA3T='cd ~/Work/Arma\ 3/Tools'
alias jIDI='cd ~/Work/IDI'
