vars() {
    DOWNLOAD_URL="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
}

check_install() {
    command -v google-chrome-stable > /dev/null
}

install() {
    [[ $DISTRO_DPKG == "0" ]] && return
    local tmp_dir=$(mktemp -d)
    local deb_file="$tmp_dir/chrome.deb"
    curl -fsSL "$DOWNLOAD_URL" > "$deb_file"
    sudo dpkg -i "$deb_file"
    rm -rf "$tmp_dir"
}

uninstall() {
    [[ $DISTRO_DPKG == "0" ]] && return
    sudo dpkg -r google-chrome-stable
}
