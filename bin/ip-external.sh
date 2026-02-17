#!/bin/sh

NIX_DEPS="nixpkgs#coreutils nixpkgs#dnsutils"

ensure_nix_shell() {
    [ -n "${NIX_SHELL:-}" ] && return 0
    command -v nix >/dev/null 2>&1 || return 0
    [ -n "${NIX_DEPS:-}" ] || return 0

    export NIX_SHELL=1
    # shellcheck disable=SC2086
    exec nix shell $NIX_DEPS --command "${BASH:-sh}" "$0" "$@"
}
ensure_nix_shell "$@"

# curl ipecho.net/plain -s | xargs echo
dig +short myip.opendns.com @resolver1.opendns.com
