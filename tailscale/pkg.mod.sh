check_install() {
    command -v tailscale > /dev/null
}

install() {
    curl -fsSL https://tailscale.com/install.sh | sh
}

post_install() {
    sudo tailscale up
}

pre_uninstall() {
    sudo tailscale down
}

uninstall() {
    sudo apt autopurge tailscale
}

purge() {
    sudo apt autopurge tailscale-archive-keyring
    sudo rm /etc/apt/sources.list.d/tailscale.list
}
