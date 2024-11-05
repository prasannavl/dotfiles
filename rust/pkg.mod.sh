vars() {
    BASH_COMPLETIONS_DIR=$HOME/.bashrc.d/completions
    COMPLETION_BINS=(
        rustup
        cargo
    )
}

check_install() {
    command -v rustup > /dev/null
}

install() {
    # for all options:
    # curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --help
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
    after_install
}

after_install() {
    # we source it so we have access in the tmp shell
    source $HOME/.cargo/env

    # install completions
    for bin in "${COMPLETION_BINS[@]}"; do
        rustup completions bash $bin > "$BASH_COMPLETIONS_DIR/$bin"
    done

    rustup component add rust-analyzer
    rustup target add wasm32-unknown-unknown
    rustup toolchain add nightly
}

uninstall() {
    # remove completions
    for bin in "${COMPLETION_BINS[@]}"; do
        rm -f "$BASH_COMPLETIONS_DIR/$bin"
    done

    rustup self uninstall -y
    rm -rf "$HOME/.rustup"
}

purge() {
    rm -rf "$HOME/.cargo"
}
