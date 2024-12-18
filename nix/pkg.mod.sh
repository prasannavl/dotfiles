vars() {
    BASH_COMPLETIONS_DIR=$HOME/.bashrc.d/completions
    case $DISTRO in
        ubuntu|debian) PKGS=(nix-bin);;
        arch) PKGS=(nix);;
        *) true;;
    esac
}

check_install() {
    command -v nix > /dev/null
}

install() {
    case $DISTRO in
        ubuntu|debian) debian_after_install;;
        arch) true;;
        *) true;;
    esac
}

debian_after_install() {
    sudo nix-channel --add https://nixos.org/channels/nixos-unstable unstable
    sudo nix-channel --update

    # Bug: https://bugs.launchpad.net/ubuntu/+source/nix/+bug/2064563
    # Remove PATH from /usr/lib/environment.d/nix-daemon.conf
    # sudo rm -f /usr/share/user-tmpfiles.d/nix-daemon.conf

    # Add user to nix group
    sudo usermod -a -G nix-users "$USER"

    # echo 'experimental-features = nix-command flakes' >> /etc/nix/nix.conf
    mkdir -p "$HOME/.config/nix"
    echo 'experimental-features = nix-command flakes' >> "$HOME/.config/nix/nix.conf"

    # install nix pkg itself
}
