# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# go-lang
gopath_dir="$HOME/workspace/go"
if [ $(command -v go) -a -d "$gopath_dir" ]; then
    export GOPATH="$gopath_dir"
    PATH="$gopath_dir/bin:$PATH"
fi
unset gopath_dir

# yarn

if [ $(command -v yarn) ]; then
    yarn_bin="$HOME/.yarn/bin"
    PATH="$yarn_bin:$PATH"
    unset yarn_bin

    yarn_modules="$HOME/.config/yarn/global/node_modules"
    export NODE_PATH="$yarn_modules"
    unset yarn_modules
fi


# android sdk
android_sdk=$HOME/Android/Sdk
if [ -d "$android_sdk" ]; then
    export ANDROID_HOME=$android_sdk
    export ANDROID_NDK_HOME=$ANDROID_HOME/ndk-bundle
    PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools
fi
unset android_sdk

# rust, cargo
if [ -r $HOME/.cargo/env ]; then
    source $HOME/.cargo/env
fi

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

