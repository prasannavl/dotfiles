vars() {
    LINKS=(.config/nix)
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
    # Bug: https://bugs.launchpad.net/ubuntu/+source/nix/+bug/2064563
    # Doesn't affect nix profile as much. But optionally: 
    # - Remove PATH from /usr/lib/environment.d/nix-daemon.conf
    # - sudo rm -f /usr/share/user-tmpfiles.d/nix-daemon.conf

    sudo mkdir -p /etc/user-tmpfiles.d/ /etc/environment.d/
    
    # We simply override these, so nix uses it's own default 
    # logic, which works better.
    sudo tee /etc/environment.d/nix-daemon.conf <<END
NIX_REMOTE=daemon
END
    sudo touch /etc/user-tmpfiles.d/nix-daemon.conf

    # Add user to nix group
    sudo usermod -a -G nix-users "$USER"

    # log in as group
    newgrp nix-users

    sudo nix-channel --add https://nixos.org/channels/nixos-25.11 nixpkgs
    # sudo nix-channel --add https://nixos.org/channels/nixos-unstable unstable
    sudo nix-channel --update

    # install nix pkg itself
}
