vars() {
    DOWNLOAD_URL="https://update.code.visualstudio.com/latest/linux-deb-x64/stable"
}

check_install() {
    command -v code > /dev/null
}

install() {
    local tmp_dir=$(mktemp -d)
    local deb_file="$tmp_dir/vscode.deb"
    curl -fsSL "$DOWNLOAD_URL" > "$deb_file"
    sudo dpkg -i "$deb_file"
    rm -rf "$tmp_dir"
}

uninstall() {
    echo TODO
    exit 1
}
