#!/usr/bin/env bash

NIX_DEPS="nixpkgs#bash nixpkgs#coreutils"

ensure_nix_shell() {
    [ -n "${NIX_SHELL:-}" ] && return 0
    command -v nix >/dev/null 2>&1 || return 0
    [ -n "${NIX_DEPS:-}" ] || return 0

    export NIX_SHELL=1
    # shellcheck disable=SC2086
    exec nix shell $NIX_DEPS --command "${BASH:-sh}" "$0" "$@"
}
ensure_nix_shell "$@"

# Display world clock
set -Eeuo pipefail

setup_vars() {
    # Timezones from: /usr/share/zoneinfo/ (tzselect)
    TIME_ZONES=(
        US/Pacific
        US/Central
        US/Eastern
        UTC
        Europe/London
        Europe/Zurich
        Asia/Kolkata
        Asia/Singapore
        Asia/Tokyo
        Australia/Sydney
    )
}

main() {
    setup_vars
    local time_zones=("${TIME_ZONES[@]}")

    if [[ "$#" -gt 0 ]]; then
        for tz in "${time_zones[@]}"; do
            printf "%s\n%-22s %s\n" "------" "$tz" "$(date --date="TZ=\"$tz\" ${*:-now}")"
        done
    else
        for tz in "${time_zones[@]}"; do
            printf "%s\n%-22s %s\n" "------" "$tz" "$(TZ=$tz date)"
        done
    fi
}

main "$@"

