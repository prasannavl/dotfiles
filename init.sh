#!/bin/bash

set -Eeuo pipefail

setup_vars() {
    VIM_MINPAC_DIR=${HOME}/.vim/pack/minpac
    TMUX_TPM_DIR=${HOME}/.tmux/plugins/tpm
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
    [[ $(command -v vim) ]] && vim +PackUpdate
}

clean_tmux() {
    echo "cleaning tmux tpm"
    rm -rf "${TMUX_TPM_DIR}"
    echo "done"
}

init_tmux() {
    git clone https://github.com/tmux-plugins/tpm "${TMUX_TPM_DIR}"
    TMUX_PLUGIN_MANAGER_PATH=$TMUX_TPM_DIR $TMUX_TPM_DIR/scripts/install_plugins.sh
}

main() {
    COMMANDS=("init-stow")
    COMMANDS+=("init-vim" "clean-vim")
    COMMANDS+=("init-tmux" "clean-tmux")

    if [[ "${1-}" == "-h" || "${1-}" == "--help" ]]; then
        usage
        return 0
    fi

    ensure_script_dir
    cd "$_SCRIPT_DIR"
    trap cleanup 1 2 3 6 15 ERR

    for x in "${COMMANDS[@]}"; do
        local cmd="${1-}"
        if [[ "$x" == "${cmd}" ]]; then
            shift
            setup_vars
            ${cmd//-/_} "$@"
            cleanup
            return 0
        fi
    done

    usage
    cleanup
    return 1
}

usage() {
    echo "Usage: $0 <command>"
    echo ""
    echo "Commands:"
    echo "${COMMANDS[@]}"
}

ensure_script_dir() {
    _WORKING_DIR="$(pwd)"
    local dir="$(dirname "${BASH_SOURCE[0]}")"
    _SCRIPT_DIR="$(cd "${dir}/" && pwd)"
}

cleanup() {
    cd "$_WORKING_DIR"
}

main "$@"
