vars() {
    DOWNLOAD_URL="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
}

check_install() {
    command -v google-chrome > /dev/null
}

install() {
    local tmp_dir=$(mktemp -d)
    local deb_file="$tmp_dir/chrome.deb"
    curl -fsSL "$DOWNLOAD_URL" > "$deb_file"
    sudo dpkg -i "$deb_file"
    rm -rf "$tmp_dir"
}

uninstall() {
    echo TODO
    exit 1
}
