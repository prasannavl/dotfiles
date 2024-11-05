vars() {
    BASH_COMPLETIONS_DIR=$HOME/.bashrc.d/completions
}

check_install() {
    return 1
}

install() {
    sudo apt update

    sudo apt install git flatpak build-essential htop ranger iftop nethogs neovim
    sudo apt install curl wget aria2

    # x11
    sudo apt install x11-apps # for xeyes, etc
    sudo apt install xsel # for clipboards

    # wayland
    sudo apt install wl-clipboard

    # display stuff
    sudo apt install ddcutil

    sudo apt install nvtop iptraf-ng whois

    # gnome stuff
    sudo apt install gnome-tweaks gnome-shell-extensions

    # flatpak
    sudo apt install flatpak gnome-software-plugin-flatpak
    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    sudo apt install dconf-editor plocate

    # clear snaps
    sudo snap remove firefox thunderbird

    # mesa-utils vulkan-utils
    # python3-pip
    # python3-venv
    # podman podman-compose podman-docker
    # distrobox virt-manager
    # clang-18 llvm-18 clang-tools-18
    #
    #
    # sshfs fdfind ripgrep sqlite3 sqlite3-browser
}

flatpak_install() {
    flatpak install org.mozilla.firefox
    flatpak install dev.zed.Zed
    flatpak install com.github.tchx84.Flatseal
    flatpak install com.valvesoftware.Steam
    flatpak install net.nokyan.Resources
}

config_stuff() {
    systemctl --user enable systemd-tmpfiles-setup.service
}

after_install() {
    :
}

uninstall() {
    :
}
