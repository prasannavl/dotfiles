install() {
  # https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html
    curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

    sudo apt-get update
    sudo apt-get install -y nvidia-container-toolkit

    after_install
}

check_install() {
    command -v nvidia-ctk > /dev/null
}

uninstall() {
  sudo rm -f /etc/cdi/nvidia.yaml
  sudo apt purge nvidia-container-toolkit --autoremove
  sudo rm -f /etc/apt/sources.list.d/nvidia-container-toolkit.list
  sudo rm -f /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
}

after_install() {
  # configure cdi for podman
  # https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html
  # https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/cdi-support.html
  sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
}
