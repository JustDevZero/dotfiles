# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob nomatch notify beep
setopt EXTENDED_GLOB
setopt hist_ignore_space
setopt hist_ignore_all_dups
unsetopt appendhistory
bindkey -e

#Autocompletion styles
zstyle :compinstall filename '~/.zshrc'
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' insert-tab pending
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always

#Here it reads the other config files.
if [ -f ~/.zaliases ]; then
        . ~/.zaliases
fi

if [ -f ~/.zprograms ]; then
        . ~/.zprograms
fi

if [ -f~/.zshort ]; then
        . ~/.zshort
fi
# The following lines were added by compinstall
autoload zmv
# Lines configured by zsh-newuser-install

autoload -Uz compinit
compinit
PS1=$' %{\e[1;34m%}% %n%{\e[0m%}, %{\e[1;32m%}% Que quieres? pesao... %{\e[0m%} ~ \$
%d
> '
# End of lines added by compinstall
autoload -U colors
colors
# End of lines configured by zsh-newuser-install

#LS WITH COLORS
    export ZLS_COLORS=$LS_COLORS
    alias ls='ls -FX --format=across --color=auto'
    
# MANPAGES WITH COLORS
if [ -e $(which most) ]
then
  export PAGER='most -s'
  export LESSHISTFILE='most -s'
else
  export PAGER=less
fi

# Some usefull modules
zmodload -i zsh/complete
zmodload -i zsh/mapfile
zmodload -i zsh/mathfunc
zmodload -i zsh/complist
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof

# Autocorrectionn:
setopt CORRECT
setopt CORRECT_ALL
export SPROMPT="$(print '%{\e[31m%}Quisiste decir %S%r%s ? (n|y|e): %{\e[0m%}')"

# Autocd:
setopt AUTO_CD
setopt CDABLE_VARS
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

### DEFINING DISTRO AND EDITOR ###
[[ -e /etc/issue ]] && DISTRO=`cat /etc/issue.net | head -n 1 | awk '{print $2 }'`
EDITOR=nano
