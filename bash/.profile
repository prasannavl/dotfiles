## User profile

# Note: Use POSIX compatible syntax as this can be
# loaded by any shell.

# ======= Package managers

# nix pkgs
if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
    export XDG_DATA_DIRS=$HOME/.nix-profile/share:$XDG_DATA_DIRS
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
    mkdir -p "$gopath_dir" || true;
    PATH="$gopath_dir/bin:$PATH"
fi
unset gopath_dir

# deno
if [ -d "$HOME/.deno/bin" ]; then
    PATH="$HOME/.deno/bin:$PATH"
fi

# npm
# npm bin -g
# npm config set prefix $HOME/.npm
npm_bin="$HOME/.npm/bin"
if [ "$(command -v npm)" ] || [ -d "$npm_bin" ]; then
    PATH="$npm_bin:$PATH"
    # npm root -g
    export NODE_PATH="$HOME/.npm/lib/node_modules"
fi
unset npm_bin

# yarn
# "$(yarn --offline global dir)/node_modules"
yarn_modules="$HOME/.config/yarn/global/node_modules"
if [ "$(command -v yarn)" ] || [ -d "$yarn_modules" ]; then
    export NODE_PATH="$yarn_modules:$NODE_PATH"
fi
unset yarn_modules


# ======= Bin paths

# unmanaged opt bin
if [ -d "$HOME/opt/bin" ]; then
    PATH="$HOME/opt/bin:$PATH"
fi

# managed local bins (python default, automated
# symlinks, .local/src based builds, etc)
if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

# src repo managed bin
if [ -d "$HOME/src/scripts/bin" ]; then
    PATH="$HOME/src/scripts/bin:$PATH"
fi

# src repo managed bin
if [ -d "$HOME/src/multiverse/bin" ]; then
    PATH="$HOME/src/multiverse/bin:$PATH"
fi

# unmanaged local bin
if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi

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
