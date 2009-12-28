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
bindkey "[Z" expand-or-complete-prefix

# The following lines were added by compinstall
zstyle :compinstall filename '~/.zshrc'

if [ -f ~/.zaliases ]; then
        . ~/.zaliases
fi

if [ -f ~/.zprograms ]; then
        . ~/.zprograms
fi

if [ -f~/.zshort ]; then
        . ~/.zshort
fi

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

#ls de colores
    export ZLS_COLORS=$LS_COLORS
    alias ls='ls -FX --format=across --color=auto'
    
# Man pages de color
if [ -e $(which most) ]
then
  export PAGER='most -s'
  export LESSHISTFILE='most -s'
else
  export PAGER=less
fi

# Algunos modulos utiles
zmodload -i zsh/complete
zmodload -i zsh/mapfile
zmodload -i zsh/mathfunc
zmodload -i zsh/complist
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof

# Usar la tecla ESC para limpiar terminal:
bindkey '^[' clear-screen


# Activando auto-correción:
setopt CORRECT
setopt CORRECT_ALL
export SPROMPT="$(print '%{\e[31m%}Quisiste decir %S%r%s ? (n|y|e): %{\e[0m%}')"

# Autoarranque de cd:
setopt AUTO_CD
setopt CDABLE_VARS
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

### DEFINING DISTRO AND EDITOR ###
[[ -e /etc/issue ]] && DISTRO=`cat /etc/issue.net | head -n 1 | awk '{print $2 }'`
EDITOR=nano
