#!/usr/bin/env bash

NIX_DEPS="nixpkgs#bash nixpkgs#coreutils nixpkgs#sudo nixpkgs#util-linux"

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
sudo swapoff -a || true
sudo swapon -a
