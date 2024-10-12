vars() {
    LINKS=(.config/mpv)
}

install() {
    sudo apt install mpv
}

check_install() {
    command -v mpv > /dev/null
}

uninstall() {
    sudo apt purge mpv --autoremove
}
