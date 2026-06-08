# Fallback prompt when starship is not available.
# The starship init is done at the end of zshrc.symlink.
if ! command -v starship &>/dev/null; then
    _git_branch() {
        local branch
        branch=$(git symbolic-ref --short HEAD 2>/dev/null) || return
        echo " ($branch)"
    }
    setopt PROMPT_SUBST
    PROMPT='%n@%m %~$(_git_branch) %# '
fi
