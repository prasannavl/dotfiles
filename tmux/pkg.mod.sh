vars() {
    TMUX_PLUGIN_DIR="$HOME/.config/tmux/plugins"
    TMUX_TPM_DIR="$TMUX_PLUGIN_DIR/tpm"
    LINKS=(.config)
    PKGS=(tmux)
}

check_install() {
    command -v tmux > /dev/null
}

post_link() {
  rm -rf "$TMUX_TPM_DIR"
  git clone https://github.com/tmux-plugins/tpm "$TMUX_TPM_DIR"
  $TMUX_TPM_DIR/bin/install_plugins
}

pre_unlink() {
  rm -rf "$TMUX_TPM_DIR"
}

clean_conf() {
  rm -rf "$TMUX_PLUGIN_DIR"
}
