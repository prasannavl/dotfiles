vars() {
    PKGS=(firefox)
}

check_install() {
    command -v firefox > /dev/null
}

pre_install() {
    [[ $DISTRO_DPKG == "0" ]] && return
    sudo install -d -m 0755 /etc/apt/keyrings
    wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
    gpg -n -q --import --import-options import-show /etc/apt/keyrings/packages.mozilla.org.asc | awk '/pub/{getline; gsub(/^ +| +$/,""); if($0 == "35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3") print "\nThe key fingerprint matches ("$0").\n"; else print "\nVerification failed: the fingerprint ("$0") does not match the expected one.\n"}'
    echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null
    sudo apt update
}

purge() {
    [[ $DISTRO_DPKG == "0" ]] && return
    sudo rm -rf /etc/apt/sources.list.d/mozilla.list /etc/apt/keyrings/packages.mozilla.org.asc
}
