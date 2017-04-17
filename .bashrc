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

alias sysinfo='eczo "" && neofetch && echo "" && colors'
#alias weather=''


if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi
