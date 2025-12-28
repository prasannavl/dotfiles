vars() {
    LINKS=()
    PKGS=()
}

check_install() {
    command -v niri > /dev/null
}

install() {
    nix profile add nixpkgs#niri
}

post_link() {
    local nix_share="$HOME/.nix-profile/share"
    local systemd_user="$HOME/.config/systemd/user"
    local wayland_sessions="/usr/local/share/wayland-sessions"
    local portal_dir="/usr/local/share/xdg-desktop-portal"
    
    sudo mkdir -p "$wayland_sessions" "$portal_dir"
    mkdir -p "$systemd_user"
    
    sudo cp -f "$nix_share/wayland-sessions/niri.desktop" "$wayland_sessions/niri.desktop"

    sudo sed -i "s|Exec=niri-session|Exec=$HOME/.nix-profile/bin/nixGL $HOME/.nix-profile/bin/niri|" "$wayland_sessions/niri.desktop"

    sudo ln -sf "$nix_share/xdg-desktop-portal/niri-portals.conf" "$portal_dir/niri-portals.conf"
    ln -sf "$nix_share/systemd/user/niri.service" "$systemd_user/niri.service"
    ln -sf "$nix_share/systemd/user/niri-shutdown.target" "$systemd_user/niri-shutdown.target"
    
    systemctl --user daemon-reload
}

pre_unlink() {
    local systemd_user="$HOME/.config/systemd/user"
    local wayland_sessions="/usr/local/share/wayland-sessions"
    local portal_dir="/usr/local/share/xdg-desktop-portal"
    
    sudo rm -f "$wayland_sessions/niri.desktop" "$portal_dir/niri-portals.conf"
    rm -f "$systemd_user/niri.service" "$systemd_user/niri-shutdown.target"
    systemctl --user daemon-reload
}

uninstall() {
    nix profile remove '.*niri.*'
}
