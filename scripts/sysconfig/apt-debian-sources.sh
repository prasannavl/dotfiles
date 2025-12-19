#!/usr/bin/env bash

set -Eeuo pipefail

function main() {
    local mode="${1:-"all:testing"}"
    
    case "$mode" in
        stable|testing|unstable)
            configure_debian_apt_sources_selective "$mode"
            configure_debian_apt_preferences "$mode"
            ;;
        all:stable|all:testing|all:unstable)
            local target_release="${mode#all:}"
            configure_debian_apt_sources_all
            configure_debian_apt_preferences "$target_release"
            ;;
        *)
            echo "Usage: $0 [stable|testing|unstable|all:stable|all:testing|all:unstable]"
            echo "Default: all:testing"
            exit 1
            ;;
    esac
}

function get_debian_sources_text_for_suite() {
    local suite="$1"
    local uri="https://deb.debian.org/debian/"
    
    # Use security URI for security suites
    if [[ "$suite" == *-security ]]; then
        uri="https://security.debian.org/debian-security/"
    fi
    
    cat <<END
Types: deb deb-src
URIs: $uri
Suites: $suite
Components: main non-free-firmware non-free
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

END
}

function configure_debian_apt_sources_selective() {
    local mode="$1"
    echo "Configuring Debian APT sources for mode: $mode"
    
    # Always enable stable and stable-backports
    echo "Configuring debian repo: stable"
    {
        get_debian_sources_text_for_suite stable
        get_debian_sources_text_for_suite stable-updates
        get_debian_sources_text_for_suite stable-security
    } | sudo tee /etc/apt/sources.list.d/debian-stable.sources

    echo "Configuring debian repo: stable-backports"
    get_debian_sources_text_for_suite stable-backports | sudo tee /etc/apt/sources.list.d/debian-stable-backports.sources

    # Enable testing for testing and unstable modes
    if [[ "$mode" == "testing" || "$mode" == "unstable" ]]; then
        echo "Configuring debian repo: testing"
        {
            get_debian_sources_text_for_suite testing
            get_debian_sources_text_for_suite testing-updates
            get_debian_sources_text_for_suite testing-security
        } | sudo tee /etc/apt/sources.list.d/debian-testing.sources
    fi

    # Enable unstable only for unstable mode
    if [[ "$mode" == "unstable" ]]; then
        echo "Configuring debian repo: unstable"
        get_debian_sources_text_for_suite unstable | sudo tee /etc/apt/sources.list.d/debian-unstable.sources
    fi
}

function configure_debian_apt_sources_all() {
    echo "Configuring Debian APT sources (all repositories)"
    for x in stable testing; do 
        echo "Configuring debian repo: $x"
        {
            get_debian_sources_text_for_suite $x
            get_debian_sources_text_for_suite $x-updates
            get_debian_sources_text_for_suite $x-security
        } | sudo tee /etc/apt/sources.list.d/debian-$x.sources
    done

    for x in stable-backports unstable experimental; do
        echo "Configuring debian repo: $x"
        get_debian_sources_text_for_suite $x | sudo tee /etc/apt/sources.list.d/debian-$x.sources
    done
}

function configure_debian_apt_preferences() {
    local mode="$1"
    echo "Configuring apt prefs for mode: $mode"
    
    # Strip 'all:' prefix if present
    local target_release="${mode#all:}"
    local stable_prio testing_prio unstable_prio
    
    case "$target_release" in
        stable)
            stable_prio=990
            testing_prio=200
            unstable_prio=100
            ;;
        testing)
            stable_prio=200
            testing_prio=990
            unstable_prio=100
            ;;
        unstable)
            stable_prio=100
            testing_prio=200
            unstable_prio=990
            ;;
    esac
    
    cat <<END | sudo tee /etc/apt/preferences.d/debian-main
## APT Pin-Priority Ranges
#
# - > 1000     → Force install, even downgrades.
# - 990–1000   → Default release (preferred if newer than installed).
# - 500–989    → Normal install/upgrade if higher priority isn't available.
# - 100–499    → Explicit install; sticky upgrades after install.
# - 1–99       → Explicit install; no automatic upgrades.
# - < 0        → Never install.

## Current mode: $mode

## experimental

Package: *
Pin: release o=Debian,a=experimental
Pin-Priority: 1

## unstable

Package: *
Pin: release o=Debian,a=unstable
Pin-Priority: $unstable_prio

## testing

Package: *
Pin: release o=Debian,a=testing
Pin-Priority: $testing_prio

Package: *
Pin: release o=Debian,a=testing-updates
Pin-Priority: $testing_prio

Package: *
Pin: release o=Debian,a=testing-security
Pin-Priority: $testing_prio

## stable

Package: *
Pin: release o=Debian,a=stable
Pin-Priority: $stable_prio

Package: *
Pin: release o=Debian,a=stable-updates
Pin-Priority: $stable_prio

Package: *
Pin: release o=Debian,a=stable-security
Pin-Priority: $stable_prio

Package: *
Pin: release o=Debian,a=stable-backports
Pin-Priority: $stable_prio

END
}

main "$@"