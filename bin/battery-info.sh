#!/usr/bin/env bash

NIX_DEPS="nixpkgs#bash nixpkgs#coreutils nixpkgs#upower"

ensure_nix_shell() {
    [ -n "${NIX_SHELL:-}" ] && return 0
    command -v nix >/dev/null 2>&1 || return 0
    [ -n "${NIX_DEPS:-}" ] || return 0

    export NIX_SHELL=1
    # shellcheck disable=SC2086
    exec nix shell $NIX_DEPS --command "${BASH:-sh}" "$0" "$@"
}
ensure_nix_shell "$@"

# Show battery info
upower -i /org/freedesktop/UPower/devices/battery_BAT0

# alternate options
  
# https://askubuntu.com/questions/69556/how-do-i-check-the-batterys-status-via-the-terminal/102863
# 
# grep POWER_SUPPLY_CAPACITY /sys/class/power_supply/BAT1/uevent
# acpi -V 
