# mise — polyglot version manager (used here for Ruby)
# https://mise.jdx.dev

# Common install location
if [[ -x "$HOME/.local/bin/mise" ]] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

if ! command -v mise &>/dev/null; then
    return
fi

eval "$(mise activate zsh)"
