_zsh_syntax="${DOTFILES:-$HOME/.dotfiles}/zsh/plugins/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
if [[ -f "$_zsh_syntax" ]]; then
    source "$_zsh_syntax"
fi
unset _zsh_syntax
