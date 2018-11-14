export TERM=xterm-256color
export TERMINAL=termite
export EDITOR=vim

alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ll='ls -alF --block-size=M --color=auto --group-directories-first'
alias la='ls -A'
alias l='ls -CF'

alias sysinfo='echo "" && neofetch'
alias weather='curl http://wttr.in/Lenart'

alias primusrun="vblank_mode=0 primusrun" # Disable VSYNC on Primusrun (Bumblebee)
alias git=hub # GitHub git wrapper

alias cleandisk="yay -Sc && paccache -rk1"

if [ -f /usr/share/bash-completion/completions/git ]; then
    . /usr/share/bash-completion/completions/git
fi

if [ -f /usr/share/bash-completion/completions/hub ]; then
    . /usr/share/bash-completion/completions/hub
fi

export PROMPT_COMMAND=__prompt_command
function __prompt_command() {
    export ERR=$?
    ~/.prompt.py --right
    PS1=$(~/.prompt.py --left)
}

# Jump to path aliases
if [ $(hostname) = "ancient" ]; then
    alias jS='cd ~/Data/School'
    alias jSTasks='cd ~/Data/School/FERI-Tasks/UNI-3-1'
    alias jSProj='cd ~/Data/School/FERI-Projects'
    alias jWS='cd /mnt/winE/School/FERI-RIT-UNI'
    alias jPS='cd /mnt/pcwin/School/FERI-RIT-UNI'
    alias jArma='cd ~/Data/Arma\ 3'
fi

if [ $(hostname) = "loki" ]; then
    alias jS='cd ~/Work/School'
    alias jSTasks='cd ~/Work/School/FERI-RIT-UNI/Tasks/UNI-3-1'
    alias jSProj='cd ~/Work/School/FERI-RIT-UNI/Projects'
    alias jWS='cd ~/Work/School/FERI-RIT-UNI'
    alias jPS='cd ~/Work/School/FERI-RIT-UNI'
    alias jArma='cd ~/Work/Arma\ 3'
fi
