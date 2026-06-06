# uv — fast Python package and environment manager
# https://github.com/astral-sh/uv

# Common install locations
for _uv_dir in "$HOME/.local/bin" "$HOME/.cargo/bin"; do
    if [[ -x "$_uv_dir/uv" ]] && [[ ":$PATH:" != *":$_uv_dir:"* ]]; then
        export PATH="$_uv_dir:$PATH"
    fi
done
unset _uv_dir

if ! command -v uv &>/dev/null; then
    return
fi

# Shell completions
if [[ -n "$ZSH_VERSION" ]]; then
    eval "$(uv generate-shell-completion zsh 2>/dev/null)"
elif [[ -n "$BASH_VERSION" ]]; then
    eval "$(uv generate-shell-completion bash 2>/dev/null)"
fi

# Create a venv in .venv and activate it
venv() {
    local py="${1:-python3}"
    uv venv --python "$py" && source .venv/bin/activate
}

# Activate .venv in current or parent directories
activate() {
    local dir="$PWD"
    while [[ "$dir" != "/" ]]; do
        if [[ -f "$dir/.venv/bin/activate" ]]; then
            source "$dir/.venv/bin/activate"
            return
        fi
        dir="$(dirname "$dir")"
    done
    echo "No .venv found in current or parent directories"
}
