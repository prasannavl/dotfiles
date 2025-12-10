# Helpers to keep PATH updates idempotent.

_path_add_checked() {
	local p=${1?-path required}
	local prepend=${2:-1}
	local check_dir=${3:-$p}
	[ ! -d "$check_dir" ] && return || true
	[ $(echo "$PATH" | grep "$p") ] && return || true
	[ "$prepend" = "1" ] && PATH="$p:$PATH" || PATH="$PATH:$p"
}

# Always add without dir check.
_path_add() {
	local p=${1?-path required}
	_path_add_checked "$1" "${2:-1}" /
}
