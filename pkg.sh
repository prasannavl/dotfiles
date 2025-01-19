#!/bin/bash

set -Eeuo pipefail

vars() {
  TARGET="${TARGET:-$HOME}"
  PKG_MOD_SH="${PKG_MOD_SH:-pkg.mod.sh}"
  FORCE_RELINK="${FORCE_RELINK:-0}"
  DISTRO=$(cat /etc/os-release | sed -n 's/^ID=//p')
  DISTRO_DPKG=$(echo "$DISTRO" | grep -q "^debian\|ubuntu" && echo 1 || echo 0)

  # Overriden by each pkg in a clean subshell
  # to link what they need
  LINKS=()
  PKGS=()
}

usage() {
    echo "usage: <command> <package1> [<package2> ...]"
    echo "env: "
    echo "  TARGET: \"$TARGET\" (target to install to, defaults to HOME env)"
    echo "  PKG_MOD_SH: \"$PKG_MOD_SH\" (the mod sh file to use for each module)"
    echo "  FORCE_RELINK: \"$FORCE_RELINK\" (force relink without requiring unlink or fail for safety)"
    echo "commands: "
    echo "  sync: brings everything up to date: check_install [install], [re]link"
    echo "  install: install the package"
    echo "  check_install: check if package requires installation"
    echo "  uninstall: uninstall the package"
    echo "  link: link the package, can fail if links already exist"
    echo "  relink: force re-link the package"
    echo "  unlink: unlink the package"
    echo "  clean_conf: clean the package configuration"
    echo "  clean: unlink, clean_conf and cleans other files"
    echo "  purge: uninstall, clean and purge other files"
}

main() {
    setup_dir_env
    cd "$_SCRIPT_DIR"
    trap cleanup 1 2 3 6 15 ERR

    vars
    if [[ "$#" -lt 2 ]]; then usage; exit 1; fi
    local cmd="$1"
    shift

    local pkgs=("$@")
    local target="$TARGET"
    local pkg_mod_file="$PKG_MOD_SH"

    local cmd_list=(
        sync
        link
        relink
        unlink
        check_install
        install
        uninstall
        clean_conf
        clean
        purge
    )

    if [[ ! " ${cmd_list[@]} " =~ " $cmd " ]]; then
        usage
        exit 1
    fi

    local x
    for x in "${pkgs[@]}"; do
        echo "=== $x ==="
        pushd "./$x" >/dev/null
        (
            # Note that we run all of these in a subshell giving it's mod file the
            # ability to override anything from this file and start fresh again.
            source "./$pkg_mod_file" 2>/dev/null || true
            run_cmd "$cmd"
        )
        popd >/dev/null
    done
    cleanup
}

run_cmd() {
    # Note that this is always called by the subshell for each pkg
    # in the working dir of the pkgs
    local cmd=${1-cmd required}
    vars
    zeroconf_var_links
    case "$cmd" in
        install)
        _install;;
        uninstall)
        _uninstall;;
        purge)
        _purge;;
        clean)
        _clean;;
        *) "$cmd";;
    esac
}

pkg_install() {
    local pkg=("${PKGS[@]}")
    [[ ${#pkg[@]} -eq 0 ]] && return 0;
    local distro="$DISTRO"
    case $distro in
        debian|ubuntu) sudo apt install "${pkg[@]}";;
        arch) sudo pacman -S "${pkg[@]}";;
        # we don't install anything on unsupported distros
        *) return 0;;
    esac
}

pkg_uninstall() {
    local pkg=("${PKGS[@]}")
    [[ ${#pkg[@]} -eq 0 ]] && return 0;
    local distro="$DISTRO"
    case $distro in
        debian|ubuntu) sudo apt purge "${pkg[@]}" --autoremove;;
        arch) sudo pacman -Rns "${pkg[@]}";;
        # we don't uninstall anything on unsupported distros
        *) return 0;;
    esac
}

zeroconf_var_links() {
    # if there are no links or PKG_MOD_SH file, then we'll link everything
    # in the current directory.
    if [[ ${#LINKS[@]} -eq 0 ]] && [[ ! -f "$PKG_MOD_SH" ]]; then
        LINKS=($(ls -A))
    fi
}

sanity_check_link() {
    local src="${1?-src required}"
    local target="${2?-target required}"

    if [[ "$src" =~ ^[[:space:]]*$ ]]; then
        echo "link: empty or whitepace in links; likely mistake in pkg; abort"
        exit 1
    fi
    # we remove existing dir in place of links only if it was
    # empty, otherwise err for user guidance.
    if [[ ! -L "$target" ]] && [[ -d "$target" ]]; then
        rmdir "$target"
    fi
}

link() {
    pre_link
    local target="$TARGET"
    local links=("${LINKS[@]}")

    local link_opts=""
    if [[ "$FORCE_RELINK" == "1" ]]; then
      link_opts="-f"
    fi

    local item_src
    local item_t
    for x in "${links[@]}"; do
        item_t="$target/$x"
        sanity_check_link "$x" "$item_t"
        item_src="$(pwd)/$x"
        echo "ln: $item_t -> $item_src"
        ln $link_opts -ns "$item_src" "$item_t"
    done
    post_link
}

unlink() {
    pre_unlink
    local target="$TARGET"
    local links=("${LINKS[@]}")
    for x in "${links[@]}"; do
        echo "rm: $target/$x"
        rm -f "$target/$x"
    done
    post_unlink
}

relink() { FORCE_RELINK=1 link; }

sync() {
    if ! check_install; then _install; fi
    relink
}

_install() {
    pre_install
    pkg_install
    install
    post_install
}

_uninstall() {
    pre_uninstall
    pkg_uninstall
    uninstall
    post_uninstall
}

_purge() {
    _clean
    _uninstall
    purge
}

_clean() {
    unlink
    clean_conf
    clean
}

# Stub functions to be overriden by pkgs
# -- false defaults
check_install() { false; }

# -- true / empty defaults
pre_install() { true; }
install() { true; }
post_install() { true; }

pre_uninstall() { true; }
uninstall() { true; }
post_uninstall() { true; }

pre_link() { true; }
post_link() { true; }

pre_unlink() { true; }
post_unlink() { true; }

clean_conf() { true; }
clean() { true; }
purge() { true; }

setup_dir_env() {
    _WORKING_DIR="$(pwd)"
    local dir="$(dirname "${BASH_SOURCE[0]}")"
    _SCRIPT_DIR="$(cd "${dir}/" && pwd)"
}

cleanup() {
    cd "$_WORKING_DIR"
}

main "$@"
