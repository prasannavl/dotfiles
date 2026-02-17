#!/usr/bin/env bash

NIX_DEPS="nixpkgs#bash nixpkgs#coreutils nixpkgs#findutils"

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
    if [[ $# -lt 1 || $# -gt 2 ]]; then
        echo "Usage: $0 device_number [brightness_to_set]"
        echo 
        # ls -ld /sys/class/backlight/ddcci*
        find /sys/class/backlight/ -type l -name "ddcci*" -exec \
         sh -c "echo \$(basename {}): \$(readlink -e {})" \;
        return 1
    fi
    local device_num=${1?-device number required}
    shift
    ensure_script_dir
    BRIGHTNESS_DEVICE="/sys/class/backlight/ddcci${device_num}" "${_SCRIPT_DIR}/brightness.sh" "$@"
}

ensure_script_dir() {
    _WORKING_DIR="$(pwd)"
    local dir="$(dirname "${BASH_SOURCE[0]}")"
    _SCRIPT_DIR="$(cd "${dir}/" && pwd)"
}

main "$@"
