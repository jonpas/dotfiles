#
# ~/.bashrc
#

export TERM=xterm-256color
export EDITOR=vim
export MANPAGER="env MAN_PN=1 vim -M +MANPAGER -"

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

# Jump to path aliases
alias jS='cd ~/Data/School'
alias jSTasks='cd ~/Data/School/FERI-Tasks/UNI-2-1'
alias jWS='cd /mnt/winE/School/FERI-RIT-UNI'
alias jPS='cd /mnt/pcwin/School/FERI-RIT-UNI'

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

GIT_PS1_SHOWDIRTYSTATE=auto
GIT_PS1_SHOWSTASHSTATE=auto
GIT_PS1_SHOWUNTRACKEDFILES=auto
GIT_PS1_SHOWUPSTREAM=auto
source /usr/share/git/completion/git-prompt.sh
PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '
