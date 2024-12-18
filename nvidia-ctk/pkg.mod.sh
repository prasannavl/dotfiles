vars() {
    PKGS=(nvidia-container-toolkit)
}

check_install() {
    command -v nvidia-ctk > /dev/null
}

pre_install() {
    [[ $DISTRO_DPKG == "0" ]] && return
    # https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html
    curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | \
        sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
        && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
        sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
        sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
    sudo apt-get update
}

post_install() {
    [[ $DISTRO_DPKG == "0" ]] && return
    # configure cdi for podman
    # https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html
    # https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/cdi-support.html
    sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
}

purge() {
    sudo rm -f /etc/cdi/nvidia.yaml || true
    sudo rm -f /etc/apt/sources.list.d/nvidia-container-toolkit.list || true
    sudo rm -f /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg || true
}
