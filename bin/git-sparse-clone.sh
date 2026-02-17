#!/bin/sh

NIX_DEPS="nixpkgs#coreutils nixpkgs#git"

ensure_nix_shell() {
    [ -n "${NIX_SHELL:-}" ] && return 0
    command -v nix >/dev/null 2>&1 || return 0
    [ -n "${NIX_DEPS:-}" ] || return 0

    export NIX_SHELL=1
    # shellcheck disable=SC2086
    exec nix shell $NIX_DEPS --command "${BASH:-sh}" "$0" "$@"
}
ensure_nix_shell "$@"

function git_sparse_clone() (
  rurl="$1" localdir="$2" && shift 2

  mkdir -p "$localdir"
  cd "$localdir"

  git init
  git remote add -f origin "$rurl"

  git config core.sparseCheckout true

  # Loops over remaining args
  for i; do
    echo "$i" >> .git/info/sparse-checkout
  done

  git pull origin master
)

git_sparse_clone "$@"
