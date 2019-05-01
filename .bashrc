export TERMINAL=termite #alacritty https://github.com/tomaka/winit/issues/705
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
    ~/.cargo/bin/prompt-rs --right
    PS1=$(~/.cargo/bin/prompt-rs --left)
}

# Disable dotnet telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# Jump to path aliases
alias jS='cd ~/Work/School'
alias jST='cd ~/Work/School/FERI-RIT-UNI/Tasks/UNI-3-2'
alias jSD='cd ~/Work/School/FERI-RIT-UNI/Data-3-2'
alias jSP='cd ~/Work/School/FERI-RIT-UNI/Projects'
alias jWS='cd ~/Work/School/FERI-RIT-UNI'
alias jPS='cd ~/Work/School/FERI-RIT-UNI'
alias jA3='cd ~/Work/Arma\ 3'
alias jA3M='cd ~/Work/Arma\ 3/Mods'
alias jA3T='cd ~/Work/Arma\ 3/Tools'
