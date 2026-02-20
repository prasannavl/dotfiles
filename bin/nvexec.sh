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

# Nvidia optimus
# https://download.nvidia.com/XFree86/Linux-x86_64/440.82/README/primerenderoffload.html
# https://download.nvidia.com/XFree86/Linux-x86_64/440.82/README/dynamicpowermanagement.html
# __GL_SYNC_TO_VBLANK=0 for vsync off 

__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=NVIDIA_only "$@"
