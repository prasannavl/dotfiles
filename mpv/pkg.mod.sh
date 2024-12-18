vars() {
    LINKS=(.config/mpv)
    PKGS=(mpv)
}

check_install() {
    command -v mpv > /dev/null
}
