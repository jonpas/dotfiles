stty stop undef # Disable Ctrl-s to freeze terminal (must be above p10k instant prompt)

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

wintitle() { echo -ne "\033];$TERMINAL: $(pwd) \007" }
precmd_functions+=(wintitle)
setname() { i3-msg title_format "$@" }
setnamep() { i3-msg focus parent, title_format "$@", focus child }

# Zsh options
setopt autocd
setopt interactive_comments
setopt no_auto_remove_slash

# History in cache directory
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.cache/zsh/history

# Basic auto/tab complete
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots) # include hidden files

setopt magicequalsubst

export TERMINAL=kitty
export EDITOR=vim

# vi-mode
bindkey -v
KEYTIMEOUT=5
bindkey -v '^?' backward-delete-char # fix backspace deletion after re-entering insert mode
# hjkl autocomplete menu select
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# Edit line in vim with Ctrl-e
autoload edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

[ -f "/usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" ] && source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

[ -f "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^f' autosuggest-accept

# fzf
export FZF_DEFAULT_COMMAND='fd --hidden --follow --exclude ".git"' # use with fd instead of find
[ -f "/usr/share/fzf/key-bindings.zsh" ] && source /usr/share/fzf/key-bindings.zsh
[ -f "/usr/share/fzf/completion.zsh" ] && source /usr/share/fzf/completion.zsh

[ -d "~/.cargo/bin" ] && PATH=$PATH:~/.cargo/bin
PATH=$PATH:~/.local/bin

# Disable dotnet telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# Aliases
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
alias ptt='sudo python ~/dotfiles/lib/ptt.py'

alias vcam="sudo modprobe v4l2loopback exclusive_caps=1 card_label='OBS Virtual Camera'"
alias vcamrm="sudo modprobe -r v4l2loopback"

alias matlab='matlab -desktop -nosplash -useStartupFolderPref'

alias fsmaps='ranger ~/Work/TARGET/Mappings'

# Signal on yay exit (i3block)
yay() {
    command yay "$@" &&
    pkill -RTMIN+4 i3status-rs
}

# GPU Offload
gpu() {
    DRI_PRIME=1 "$@"  # PRIME
}

alias obs='vk_pro obs'  # AMD AMF (hardware encoder) with AMDGPU PRO

# VNC screens
vnc() {
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

# Require virtualenv for pip
export PIP_REQUIRE_VIRTUALENV=true
pip-global() {
    PIP_REQUIRE_VIRTUALENV=false pip "$@"
}

# init-vm.sh is slow, only init on request
if [ -f /usr/share/nvm/init-nvm.sh ]; then
    alias nvminit='. /usr/share/nvm/init-nvm.sh'
fi

# Bind fg for switching between vim and terminal (C-z / C-z) if interactive shell
if [[ "$-" =~ "i" ]]; then
    function fgswitch { fg }
    zle -N fgswitch
    bindkey '^Z' fgswitch
fi

# https://github.com/gujiaxi/ranger-cd/blob/master/ranger-cd.zsh
function ranger-cd {
    tempfile="$(mktemp -t tmp.XXXXXX)"
    /usr/bin/ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}
bindkey -s '^O' 'ranger-cd\n'

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
