if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
else
    _git_branch() {
        local branch
        branch=$(git symbolic-ref --short HEAD 2>/dev/null) || return
        echo " ($branch)"
    }
    setopt PROMPT_SUBST
    PROMPT='%n@%m %~$(_git_branch) %# '
fi
