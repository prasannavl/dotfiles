vars() {
    DOWNLOAD_URL="https://update.code.visualstudio.com/latest/linux-deb-x64/stable"
}

check_install() {
    command -v code > /dev/null
}

install() {
    [[ $DISTRO_DPKG == "0" ]] && return
    local tmp_dir=$(mktemp -d)
    local deb_file="$tmp_dir/vscode.deb"
    curl -fsSL "$DOWNLOAD_URL" > "$deb_file"
    sudo dpkg -i "$deb_file"
    rm -rf "$tmp_dir"
}

uninstall() {
    [[ $DISTRO_DPKG == "0" ]] && return
    sudo dpkg -r vscode
}
