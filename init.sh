#!/bin/bash

set -Eeuo pipefail

setup_vars() {
  STOW_TARGET="${STOW_TARGET:-${HOME}}"
  TMUX_TPM_DIR="${HOME}/.tmux/plugins/tpm"
}

init_stow() {
  local stow_target="${STOW_TARGET}"
  local stow_dirs
  stow_dirs=$(find . -maxdepth 1 -not \( -path . -o -path ./.git \) -type d)
  
  local x
  for x in ${stow_dirs}; do
    stow -t "${stow_target}" -v ${x#\./}
  done
}

init_tmux() {
  git clone https://github.com/tmux-plugins/tpm "${TMUX_TPM_DIR}"
  $TMUX_TPM_DIR/bin/install_plugins
}

clean_tmux() {
  echo "cleaning tmux tpm"
  rm -rf "${TMUX_TPM_DIR}"
  echo "done"
}

main() {
  COMMANDS=("init-stow")
  COMMANDS+=("init-tmux" "clean-tmux")

  if [[ "${1-}" == "-h" || "${1-}" == "--help" ]]; then
    usage
    return 0
  fi

  setup_dir_env
  cd "$_SCRIPT_DIR"
  trap cleanup 1 2 3 6 15 ERR

  local x
  for x in "${COMMANDS[@]}"; do
    local cmd="${1-}"
    if [[ "$x" == "${cmd}" ]]; then
      shift
      setup_vars
      ${cmd//-/_} "$@"
      cleanup
      return 0
    fi
  done

  usage
  cleanup
  return 1
}

usage() {
  echo "Usage: $0 <command>"
  echo ""
  echo "Commands:"
  echo "${COMMANDS[@]}"
}

setup_dir_env() {
  _WORKING_DIR="$(pwd)"
  local dir="$(dirname "${BASH_SOURCE[0]}")"
  _SCRIPT_DIR="$(cd "${dir}/" && pwd)"
}

cleanup() {
  cd "$_WORKING_DIR"
}

main "$@"
