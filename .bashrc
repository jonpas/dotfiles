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

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

export PROMPT_COMMAND=__prompt_command
function __prompt_command() {
    export ERR=$?
    ~/.prompt.py --right
    PS1=$(~/.prompt.py --left)
}

# Jump to path aliases
alias jS='cd ~/Data/School'
alias jSTasks='cd ~/Data/School/FERI-Tasks/UNI-2-2'
alias jSProj='cd ~/Data/School/FERI-Projects'
alias jWS='cd /mnt/winE/School/FERI-RIT-UNI'
alias jPS='cd /mnt/pcwin/School/FERI-RIT-UNI'
