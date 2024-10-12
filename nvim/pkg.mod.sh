vars() {
    LINKS=(".config/nvim")
}

check_install() {
    command -v nvim > /dev/null
}

install() {
    sudo apt install neovim
}

uninstall() {
    sudo apt purge neovim --autoremove
}

purge() {
    rm -rf ~/.local/share/nvim
    rm -rf ~/.local/state/nvim
    rm -rf ~/.cache/nvim
}
