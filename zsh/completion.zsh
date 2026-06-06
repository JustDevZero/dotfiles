zstyle :compinstall filename '~/.zshrc'
zstyle ':completion:*' insert-tab pending
zstyle ':completion:*:functions' ignored-patterns '_*'

# completers: expand → complete → correct → approximate
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# cd: no seleccionar directorio padre
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# caché
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/completion_$HOST"

# expansiones
zstyle ':completion:*:expand:*' tag-order all-expansions
zstyle ':completion:*' expand prefix

# lista
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'

# case insensitive
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
zstyle ':completion:*:processes-names' command 'ps axho command'
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.~*~' '*?.class' '*?.swp' '*?.obj'

# kill
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always
zstyle ':completion:*:*:kill:*:processes' command 'ps --forest -A -o pid,user,cmd'

# SSH/SCP — completa desde .ssh/config y known_hosts
zstyle ':completion:*:scp:*' tag-order files 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:scp:*' group-order files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:ssh:*' group-order hosts-domain hosts-host hosts-ipaddr

# mensajes
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BNo hay resultados para: %d%b'
