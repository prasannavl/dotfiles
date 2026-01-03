vars() {
    LINKS=(.config/nvim)
    PKGS=(neovim)
}

check_install() {
    command -v nvim > /dev/null
}

purge() {
    rm -rf ~/.local/share/nvim
    rm -rf ~/.local/state/nvim
    rm -rf ~/.cache/nvim
}
