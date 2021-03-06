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

#####      KEYBINDINGS     #####
bindkey -e
typeset -g -A key
bindkey "^[Z" expand-or-complete-prefix
bindkey "\e[1~" beginning-of-line   # Linux console
bindkey '\e[H'    beginning-of-line  # xterm
bindkey '\eOH' beginning-of-line   # gnome-terminal
bindkey "\e[4~" end-of-line  # Linux console
bindkey '\e[F'    end-of-line        # xterm
bindkey '\eOF' end-of-line # gnome-terminal
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[3~" delete-char
bindkey "5C" forward-word
bindkey "\e[5C" emacs-forward-word
bindkey "\e[5D" emacs-backward-word
bindkey "5D" backward-word
bindkey "2~" backward-delete-word
bindkey "5~" delete-word
bindkey '5A' up-line-or-history
bindkey '5B' down-line-or-history
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
