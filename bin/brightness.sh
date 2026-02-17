#!/usr/bin/env bash

NIX_DEPS="nixpkgs#bash nixpkgs#coreutils nixpkgs#sudo"

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
setup_vars() {
    BRIGHTNESS_DEVICE=${BRIGHTNESS_DEVICE:-"/sys/class/backlight/intel_backlight"}
    #BRIGHTNESS_DEVICE=${BRIGHTNESS_DEVICE:-"/sys/class/backlight/nvidia_wmi_ec_backlight"}
}

main() {
    setup_vars
    local val=${1:--1}
    if [[ $val -gt -1 ]]; then
        set $val
    else
        get
    fi
}

get() {
    local device=$BRIGHTNESS_DEVICE
    local max;
    max=$(cat $device/max_brightness)
    local actual;
    actual=$(cat $BRIGHTNESS_DEVICE/brightness)
    local val=$(( actual * 100 / max ))
    echo "$actual ($val%)"
}

set() {
    local device=$BRIGHTNESS_DEVICE
    local val=$1
    local max;
    max=$(cat $device/max_brightness)
    local actual=$(( val * max / 100))
    echo "set:" $(sudo tee $device/brightness <<< $actual) "($val%)"
}

main "$@"
