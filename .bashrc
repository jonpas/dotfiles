export TERMINAL=termite #alacritty https://github.com/tomaka/winit/issues/705
export EDITOR=vim

alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ll='ls -alhF --color=auto --group-directories-first'
alias la='ls -A'
alias l='ls -CF'

alias fd="fd --hidden"

alias sysinfo='echo "" && neofetch'
alias weather='curl http://wttr.in/Lenart'
alias vm='sudo ~/dotfiles/vm/win10-pci.sh'

alias git=hub # GitHub git wrapper
alias cleandisk="yay -Sc && paccache -rk1"

# Bind fg for switching between vim and terminal (C-z / C-a)
bind -x '"\C-a":"fg"'

if [ -f /usr/share/bash-completion/completions/git ]; then
    . /usr/share/bash-completion/completions/git
fi

if [ -f /usr/share/bash-completion/completions/hub ]; then
    . /usr/share/bash-completion/completions/hub
fi

export PROMPT_COMMAND=__prompt_command
function __prompt_command() {
    export ERR=$?

    prompt-rs --right
    PS1=$(prompt-rs --left)

    # Window title
    echo -ne "\033]0;$TERMINAL: $(pwd) \007"
}

# VTE (termite) open terminal in the current directory
if [[ $TERM == xterm-termite ]]; then
    . /etc/profile.d/vte.sh
    __prompt_command
fi

# Disable dotnet telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

PATH=$PATH:~/.cargo/bin

# Jump to path aliases
alias jL='cd ~/Work/Linux'
alias jS='cd ~/Work/School/FERI-RIT-UNI'
alias jST='cd ~/Work/School/FERI-RIT-UNI/Tasks/UNI-3-2'
alias jSD='cd ~/Work/School/FERI-RIT-UNI/Data-3-2'
alias jSP='cd ~/Work/School/FERI-RIT-UNI/Projects'
alias jA3='cd ~/Work/Arma\ 3'
alias jA3M='cd ~/Work/Arma\ 3/Mods'
alias jA3T='cd ~/Work/Arma\ 3/Tools'
