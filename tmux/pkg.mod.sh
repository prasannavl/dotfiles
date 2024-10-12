vars() {
    TMUX_PLUGIN_DIR="$HOME/.tmux/plugins"
    TMUX_TPM_DIR="$TMUX_PLUGIN_DIR/tpm"
    LINKS=(
        .tmux.conf
        )
}

after_link() {
  rm -rf "$TMUX_TPM_DIR"
  git clone https://github.com/tmux-plugins/tpm "$TMUX_TPM_DIR"
  $TMUX_TPM_DIR/bin/install_plugins
}

before_unlink() {
  rm -rf "$TMUX_TPM_DIR"
}

clean_conf() {
  rm -rf "$TMUX_PLUGIN_DIR"
}

check_install() {
    command -v tmux > /dev/null
}

install() {
  sudo apt install tmux
}

uninstall() {
  sudo apt purge tmux --autoremove
}
