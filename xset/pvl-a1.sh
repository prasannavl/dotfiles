#!/bin/bash

PKGS=(
    bash
    tmux
    nvim
    nerd-fonts
    deno
    rust
    nvidia-ctk
    nautilus-hidden
    xdg-templates
    mpv
    x/quilt
)

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
"$SCRIPT_DIR/../pkg.sh" "$@" "${PKGS[@]}"
