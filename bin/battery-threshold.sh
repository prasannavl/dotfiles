#!/usr/bin/env bash

NIX_DEPS="nixpkgs#bash nixpkgs#coreutils nixpkgs#gnugrep nixpkgs#sudo"

ensure_nix_shell() {
    [ -n "${NIX_SHELL:-}" ] && return 0
    command -v nix >/dev/null 2>&1 || return 0
    [ -n "${NIX_DEPS:-}" ] || return 0

    export NIX_SHELL=1
    # shellcheck disable=SC2086
    exec nix shell $NIX_DEPS --command "${BASH:-sh}" "$0" "$@"
}
ensure_nix_shell "$@"

set -Eeuo pipefail
main() {
    local start=${1:--1}
    local end=${2:--1}
    if [[ $start -gt -1 ]] && [[ $end -gt -1 ]]; then
        set $start $end
    else
        get
    fi
}

get() {
    grep "" /sys/class/power_supply/BAT*/charge_*
}

set() {
    echo "set BAT0 start:" $(sudo tee /sys/class/power_supply/BAT0/charge_start_threshold <<< $1)
    echo "set BAT0 end:" $(sudo tee /sys/class/power_supply/BAT0/charge_stop_threshold <<< $2)
}

main "$@"
