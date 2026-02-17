#!/usr/bin/env bash

NIX_DEPS="nixpkgs#bash nixpkgs#coreutils nixpkgs#openssh nixpkgs#tmux"

ensure_nix_shell() {
    [ -n "${NIX_SHELL:-}" ] && return 0
    command -v nix >/dev/null 2>&1 || return 0
    [ -n "${NIX_DEPS:-}" ] || return 0

    export NIX_SHELL=1
    # shellcheck disable=SC2086
    exec nix shell $NIX_DEPS --command "${BASH:-sh}" "$0" "$@"
}
ensure_nix_shell "$@"

# a script to ssh multiple servers over multiple tmux panes
setup_tmux() {
    if [ -z "$HOSTS" ]; then
       echo -n "Please provide of list of hosts separated by spaces [ENTER]: "
       read HOSTS
    fi

    local hosts=($HOSTS)

    tmux new-window "ssh ${hosts[0]}"
    unset hosts[0];
    for i in "${hosts[@]}"; do
        tmux split-window -h  "ssh $i"
        tmux select-layout tiled > /dev/null
    done
    tmux select-pane -t 0
    tmux set-window-option synchronize-panes on > /dev/null
}

setup_vars() {
    HOSTS=${HOSTS:=$*}
}

main() {
    setup_vars "$@"
    setup_tmux
}

main "$@"

