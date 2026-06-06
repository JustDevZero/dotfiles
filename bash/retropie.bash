retropie_welcome() {
    DOTFILES_LOGO_NO_AUTO=1
    if [ -r "${DOTFILES:-$HOME/.dotfiles}/shell/logo.sh.symlink" ]; then
        . "${DOTFILES:-$HOME/.dotfiles}/shell/logo.sh.symlink"
        dotfiles_logo
    fi
    unset DOTFILES_LOGO_NO_AUTO
}
