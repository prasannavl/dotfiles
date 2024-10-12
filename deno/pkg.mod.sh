vars() {
    BASH_COMPLETIONS_DIR=$HOME/.bashrc.d/completions
}

check_install() {
    command -v deno > /dev/null
}

install() {
    curl -fsSL https://deno.land/x/install/install.sh | sh
    after_install
}

after_install() {
    deno completions bash > "$BASH_COMPLETIONS_DIR/deno"
}

uninstall() {
    rm -f "$BASH_COMPLETIONS_DIR/deno"
    rm -rf "$HOME/.deno"
}
