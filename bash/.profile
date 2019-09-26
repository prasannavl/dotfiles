# if running bash
if [[ -n "$BASH_VERSION" ]]; then
    if [[ -f "$HOME/.bashrc" ]]; then
	. "$HOME/.bashrc"
    fi
fi

# go-lang
gopath_dir="$HOME/workspace/go"
if [[ $(command -v go) && -d "$gopath_dir" ]]; then
    export GOPATH="$gopath_dir"
    PATH="$gopath_dir/bin:$PATH"
fi
unset gopath_dir

# npm, yarn
if [[ $(command -v npm) ]]; then
    # npm config set prefix $HOME/.npm
    npm_bin="$HOME/.npm/bin"
    PATH="$npm_bin:$PATH"
    unset npm_bin
fi

if [[ $(command -v yarn) ]]; then
    # export NODE_PATH="$(yarn --offline global dir)/node_modules"
    yarn_modules="$HOME/.config/yarn/global/node_modules"
    export NODE_PATH="$yarn_modules"
    unset yarn_modules
fi

# rust, cargo
if [[ -r "$HOME/.cargo/env" ]]; then
    source "$HOME/.cargo/env"
fi

# private bin paths

if [[ -d "$HOME/.local/opt/bin" ]]; then 
    PATH="$HOME/.local/opt/bin:$PATH"
fi

if [[ -d "$HOME/.local/bin" ]]; then 
    PATH="$HOME/.local/bin:$PATH"
fi

if [[ -d "$HOME/bin" ]]; then
    PATH="$HOME/bin:$PATH"
fi

export PATH


export PATH="$HOME/.cargo/bin:$PATH"
