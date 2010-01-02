# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
#SET Opp
setopt autocd extendedglob nomatch notify beep
setopt autopushd pushdminus pushdsilent pushdtohome
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt SH_WORD_SPLIT
setopt EXTENDED_GLOB
setopt cdablevars
setopt ignoreeof
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt interactivecomments
setopt nohup
setopt nobanghist
setopt noclobber
unsetopt appendhistory
setopt AUTO_CD
setopt CDABLE_VARS
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
eval `dircolors -b`

# Autocorrectionn:
setopt CORRECT
setopt CORRECT_ALL
export SPROMPT="$(print '%{\e[31m%}Quisiste decir %S%r%s ? (n|y|e): %{\e[0m%}')"

# Some usefull modules
zmodload -i zsh/complete
zmodload -i zsh/mapfile
zmodload -i zsh/mathfunc
zmodload -i zsh/complist
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
zmodload zsh/complist

#Defining exports and usefull variables
OS=`cat /etc/issue|head -n 1|awk '{print $1}'` 
DISTRO=`cat /etc/issue|head -n 1|awk '{print $2}'` 
VERSION=`cat /etc/issue|head -n 1|awk '{print $3}'` 
export EDITOR="/usr/bin/nano"
export BROWSER="/usr/bin/firefox"
export PAGER='most -s'
export LESSHISTFILE='most -s'
export ZLS_COLORS=$LS_COLORS
export PS1="$(print '%{\e[0;34m%}Daniel%{\e[0m%}'): $(print ' %{\e[0;31m%}% \ %d %{\e[0;32m%}\nQue quieres?%{\e[0m%}') "
export PS2="$(print '%{\e[0;34m%}>%{\e[0m%}')"

# Define a few Color's
BLACK='\e[0;30m'
BLUE='\e[0;34m'
GREEN='\e[0;32m'
CYAN='\e[0;36m'
RED='\e[0;31m'
PURPLE='\e[0;35m'
BROWN='\e[0;33m'
LIGHTGRAY='\e[0;37m'
DARKGRAY='\e[1;30m'
LIGHTBLUE='\e[1;34m'
LIGHTGREEN='\e[1;32m'
LIGHTCYAN='\e[1;36m'
LIGHTRED='\e[1;31m'
LIGHTPURPLE='\e[1;35m'
YELLOW='\e[1;33m'
WHITE='\e[1;37m'
NC='\e[0m'              # No Color


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

if [ -f~/.zcompletion ]; then
        . ~/.zcompletion
fi

# The following lines were added by compinstall
autoload zmv
# Lines configured by zsh-newuser-install

autoload -Uz compinit
compinit
autoload -U colors
colors
# End of lines configured by zsh-newuser-install
