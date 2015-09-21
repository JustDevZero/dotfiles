#
#		The MIT License
#
#		Copyright (c) Mephiston <meph.snake@gmail.com>
#		
#		Permission is hereby granted, free of charge, to any person obtaining a copy
#		of this software and associated documentation files (the "Software"), to deal
#		in the Software without restriction, including without limitation the rights
#		to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#		copies of the Software, and to permit persons to whom the Software is
#		furnished to do so, subject to the following conditions:
#		
#		The above copyright notice and this permission notice shall be included in
#		all copies or substantial portions of the Software.
#
#		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#		IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#		FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#		AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#		LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#		OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#		THE SOFTWARE.

# autocompletion styles
zstyle :compinstall filename '~/.zshrc'
zstyle ':completion:*' insert-tab pending
zstyle ':completion:*:functions' ignored-patterns '_*'

# allow aproximate
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# cd not select parent dir
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# fancy cache completion stuff
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh_files/cache_$HOST

# tlist of completers to use
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate

# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions
zstyle ':completion:*' expand prefix

# completion list
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'

# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# offer indexes before parameters in subscrits
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
zstyle ':completion:*:processes-names' command 'ps axho command'
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.~*~' \
'*?.class' '*?.swp' '*?.obj'

#Kill autocompletion
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always
zstyle ':completion:*:*:kill:*:processes' command 'ps --forest -A -o pid,user,cmd'


# SSH Completion (complete from hosts files, .ssh/config,known_hosts lists, etc)
zstyle ':completion:*:scp:*' tag-order \
files 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:scp:*' group-order \
files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order \
'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:ssh:*' group-order \
hosts-domain hosts-host hosts-ipaddr

# warning and descriptions
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BLo siento, no hay resultados para: %d%b'
