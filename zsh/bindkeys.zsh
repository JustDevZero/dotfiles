##### KEYBINDINGS #####
bindkey -e
typeset -g -A key

bindkey "^[Z" expand-or-complete-prefix

# Inicio / Fin — distintas secuencias según terminal
bindkey "\e[1~"  beginning-of-line   # Linux console
bindkey "\e[H"   beginning-of-line   # xterm
bindkey "\eOH"   beginning-of-line   # gnome-terminal / VTE
bindkey "\e[4~"  end-of-line         # Linux console
bindkey "\e[F"   end-of-line         # xterm
bindkey "\eOF"   end-of-line         # gnome-terminal / VTE

# Re Pág / Av Pág — navegar historial
bindkey "\e[5~"  beginning-of-history
bindkey "\e[6~"  end-of-history

# Supr
bindkey "\e[3~"  delete-char

# Ctrl+Derecha / Ctrl+Izquierda — mover por palabras
bindkey "\e[5C"  forward-word
bindkey "\e[5D"  backward-word
bindkey "\e[1;5C" forward-word       # xterm moderno
bindkey "\e[1;5D" backward-word      # xterm moderno

# Ctrl+Supr / Ctrl+Retroceso — borrar palabras
bindkey "\e[3;5~" delete-word
bindkey "\e[2~"   backward-delete-word

# Ctrl+Arriba / Ctrl+Abajo — historial
bindkey "\e[5A"  up-line-or-history
bindkey "\e[5B"  down-line-or-history
bindkey "\e[1;5A" up-line-or-history
bindkey "\e[1;5B" down-line-or-history

# Arriba / Abajo — búsqueda en historial por prefijo
bindkey "^[[A"   up-line-or-search
bindkey "^[[B"   down-line-or-search
