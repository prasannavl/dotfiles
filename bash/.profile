# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# go-lang
godir="$HOME/.local/opt/go"
gopath_dir="$HOME/workspace/go"
if [ -d "$godir" -a -d "$gopath_dir" ]; then
    export GOPATH="$gopath_dir"
    PATH="$godir/bin:$gopath_dir/bin:$PATH"
fi

# yarn
yarn_bin="$HOME/.yarn/bin"
if [ -d "$yarn_bin" ]; then 
    PATH="$yarn_bin:$PATH"
fi

yarn_modules="$HOME/.config/yarn/global/node_modules"
if [ -d "$yarn_modules" ]; then
    export NODE_PATH="$yarn_modules"
fi

# android sdk
export ANDROID_HOME=$HOME/Android/Sdk
export ANDROID_NDK_HOME=$ANDROID_HOME/ndk-bundle
PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools

# rust, cargo
PATH="$HOME/.cargo/bin:$PATH"

# private bin paths

if [ -d "$HOME/.local/opt/bin"  ]; then 
    PATH="$HOME/.local/opt/bin:$PATH"
fi

if [ -d "$HOME/.local/bin"  ]; then 
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi

export PATH

