#
#       The MIT License
#
#       Copyright (c) Daniel Ripoll, <info@danielripoll.es>, <http://danielripoll.es>
#
#       Permission is hereby granted, free of charge, to any person obtaining a copy
#       of this software and associated documentation files (the "Software"), to deal
#       in the Software without restriction, including without limitation the rights
#       to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#       copies of the Software, and to permit persons to whom the Software is
#       furnished to do so, subject to the following conditions:
#
#       The above copyright notice and this permission notice shall be included in
#       all copies or substantial portions of the Software.
#
#       THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#       IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#       FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#       AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#       LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#       OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#       THE SOFTWARE.

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



if [[ -n $SSH_CONNECTION ]]; then
    if [ $UID -eq 0 ]; then
        export PS1="$(print '%{\e[0;34m%}%n@m%{\e[0m%}'): $(print ' %{\e[0;31m%}% \ %3~ %{\e[0;32m%}\n#%{\e[0m%}') "
    else
        export PS1="$(print '%{\e[0;34m%}%n@m%{\e[0m%}'): $(print ' %{\e[0;31m%}% \ %3~ %{\e[0;32m%}\n$%{\e[0m%}') "
    fi
else
    if [ $UID -eq 0 ]; then
        export PS1="$(print '%{\e[0;34m%}%n%{\e[0m%}'): $(print ' %{\e[0;31m%}% \ %3~ %{\e[0;32m%}\n#%{\e[0m%}') "
    else
        export PS1="$(print '%{\e[0;34m%}%n%{\e[0m%}'): $(print ' %{\e[0;31m%}% \ %3~ %{\e[0;32m%}\n$%{\e[0m%}') "
    fi
fi

export PS2="$(print '%{\e[0;34m%}>%{\e[0m%}')"
eval `dircolors -b`
export CLICOLOR=true

# autoload functions only if they exist.
if [[ "$(ls -A $ZSH 2> /dev/null)" != '' ]]; then
    fpath=($ZSH/functions $fpath)
    autoload -U $ZSH/functions/*(:t)
fi


# set history to 50.000 commands, for better stadistics and don't loose commands.
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

# Misc
setopt nobgnice  # don't nice background tasks
setopt nohup
setopt localoptions # allow functions to have local options
setopt localtraps # allow functions to have local traps
setopt ignoreeof # Do not exit on end-of-file (^D).
setopt nomatch # If a pattern for filename generation has no matches, print an error
setopt notify # Get notified if some program in background receives a signal
#setopt PROMPT_SUBST # Allow for functions in the prompt.
setopt RM_STAR_WAIT # 10 second wait if you do something that will delete everything.  I wish I'd had this before...
unsetopt RM_STAR_SILENT # ask before rm*

# Beep stuff
setopt interactivecomments # Allow comments in interactive shells
setopt nobeep # Beeps are annoying
setopt nolistbeep # Same
setopt nohistbeep # Don't beep for erroneous history expansions

# Changing directories
setopt autocd  # Why would you type 'cd dir' if you could just type 'dir'?
setopt cdablevars # If argument to cd is the name of a parameter whose value is a valid directory, it will become the current directory
setopt autopushd  # This makes cd=pushd
setopt pushdignoredups  # This will ignore multiple directories for the stack.  Useful?  I dunno.
setopt pushdsilent # No more annoying pushd messages...
setopt pushdtohome # blank pushd goes to home
setopt pushdminus  #swapped the meaning of cd +1 and cd -1, otherwise is not logical for me.

# Completion
setopt extendedglob # treat #, ~, and ^ as part of patterns for filename generation
setopt alwaystoend # pretty obvious

# History
setopt histreduceblanks # Pretty obvious. Right?
setopt hist_ignore_space  # If a line starts with a space, don't save it.
setopt hist_ignore_all_dups
setopt shwordsplit # By default, zsh does not separate word in a var "word 1 word2", shwordsplit gives compatibility with it.
unsetopt banghist # we don't want the default ! behavior
setopt noclobber  # Keep echo "station" > station from clobbering station
unsetopt appendhistory #We don't want histories from others tty to be appended, only our main.

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
OS=`uname`
DISTRO=`cat /etc/os-release |grep "^NAME"|sed s'?=? ?'g |awk '{print $2}'`
VERSION=`cat /etc/os-release |grep "^VERSION_ID"|sed s'?=? ?'g |awk '{print $2}'`

export PAGER='most -s'
export LESSHISTFILE='most -s'
