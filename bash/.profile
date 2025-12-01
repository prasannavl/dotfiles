## User profile

# Note: Use POSIX compatible syntax as this can be
# loaded by any shell.

# ======= Functions

_path_add_checked() {
	local p=${1?-path required}
	local prepend=${2:-1}
	local check_dir=${3:-$p}
	[ ! -d "$check_dir" ] && return || true
	[ $(echo "$PATH" | grep "$p") ] && return || true
	[ "$prepend" == "1" ] && PATH="$p:$PATH" || PATH="$PATH:$p"
}

# ======= Package managers

# nix pkgs
if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
	. "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

# linuxbrew
# Unused, but just in case needed
if [ -f "$HOME/.linuxbrew/bin/brew" ]; then
	eval "$("$HOME/.linuxbrew/bin/brew shellenv")"
elif [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# ======= Lang-specific

# rust, cargo
if [ -r "$HOME/.cargo/env" ]; then
	. "$HOME/.cargo/env"
fi

# go-lang
gopath_dir="$HOME/src/go"
if [ "$(command -v go)" ] || [ -d "$gopath_dir" ]; then
	export GOPATH="$gopath_dir"
	mkdir -p "$gopath_dir" || true
	PATH="$gopath_dir/bin:$PATH"
fi
unset gopath_dir

# deno
_path_add_checked $HOME/.deno/bin

# npm
# npm bin -g
# npm config set prefix $HOME/.npm
npm_bin="$HOME/.npm/bin"
if [ "$(command -v npm)" ] || [ -d "$npm_bin" ]; then
	PATH="$npm_bin:$PATH"
	# npm root -g
	export NODE_PATH="$HOME/.npm/lib/node_modules:$NODE_PATH"
fi
unset npm_bin

# yarn
# "$(yarn --offline global dir)/node_modules"
yarn_modules="$HOME/.config/yarn/global/node_modules"
yarn_bin="$HOME/.yarn/bin"
if [ "$(command -v yarn)" ] || [ -d "$yarn_modules" ] || [ -d "$yarn_bin" ]; then
	PATH="$yarn_bin:$PATH"
	export NODE_PATH="$yarn_modules:$NODE_PATH"
fi
unset yarn_modules
unset yarn_bin

# ======= Bin paths

# unmanaged opt bin
_path_add_checked $HOME/opt/bin
# managed local bins (py default, auto symlinks, .local/src based builds, etc)
_path_add_checked $HOME/.local/bin
# src repo managed bin
_path_add_checked $HOME/src/scripts/bin
_path_add_checked $HOME/src/scripts/sbin
# src repo managed bin
_path_add_checked $HOME/src/multiverse/bin
# unmanaged local bin
_path_add_checked $HOME/bin

export PATH

# ======= Host specific

if [ -f "$HOME/.profile.local" ]; then
	. "$HOME/.profile.local"
fi

# ======= Bash RC

# If bash, we call into bashrc to make things
# consistent and have a simpler mental model
if [ -n "$BASH_VERSION" ]; then
	if [ -f "$HOME/.bashrc" ]; then
		. "$HOME/.bashrc"
	fi
fi

# === Global envs
#
export ELECTRON_OZONE_PLATFORM_HINT=auto
