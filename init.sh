#!/bin/bash

setup_vars() {
    VIM_MINPAC_DIR=${HOME}/.vim/pack/minpac
    TMUX_TPM_DIR="${HOME}/.tmux/plugins/tpm"
}

main() {
    init_stow
}

init_stow() {
    stow_dirs=$(find . -maxdepth 1 -not \( -path . -o -path ./.git \) -type d)
    for x in ${stow_dirs}; do
        stow -v ${x#\./}
    done
}

clean_vim() {
    echo "cleaning vim: minpac"
    rm -rf ${VIM_MINPAC_DIR}
    echo "done"
}

init_vim() {
    git clone https://github.com/k-takata/minpac.git ${VIM_MINPAC_DIR}/opt/minpac
    [ $(command -v vim) ] && vim +PackUpdate
}

clean_tmux() {
    echo "cleaning tmux tpm"
    rm -rf "${TMUX_TPM_DIR}"
    echo "done"
}

init_tmux() {
    git clone https://github.com/tmux-plugins/tpm "${TMUX_TPM_DIR}"
    $TMUX_TPM_DIR/scripts/install_plugins.sh
}

run() {
    init
    if [ -z "$@" ]; then
        main "$@"
    else
        eval "$@"
    fi
    cleanup
}

init() {
    if [ -z "$_INIT" ]; then
        _INIT="1"
    else
        return 0
    fi
    set -Eeuo pipefail
    _OPWD="$(pwd)"
    trap cleanup 1 2 3 6 15 ERR

    # script dir
    local dir="$(dirname "${BASH_SOURCE[0]}")"
    _SPWD="$(cd "${dir}/" && pwd)"
    cd "${_SPWD}"
    if [ "$(type -t setup_vars)" == "function" ]; then
        setup_vars
    fi
}

cleanup() {
    cd "$_OPWD"
}

run "$@"
