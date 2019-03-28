# some functions

function mkcd() {
    mkdir -p "$@" && cd "$@"
}

function c() {
    bc <<<"scale=20;$@"
}

function wttr() {
    curl http://wttr.in/$@
}

function android_sdk_env() {
    android_sdk=$HOME/Android/Sdk
    if [[ -d "$android_sdk" ]]; then
        export ANDROID_HOME=$android_sdk
        export ANDROID_NDK_HOME=$ANDROID_HOME/ndk-bundle
        PATH="$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH"
    fi
    unset android_sdk
}

function __get_cargo_lib_crates() {
    echo -n "log failure futures tokio itertools serde serde_json lazy_static chrono clap rand time tokio-threadpool hyper"
}

function __get_cargo_bin_crates() {
    echo -n "env_logger exitfailure structopt"
}

function cargo_init_bin() {
    local name=${1:?name not set}
    cargo init --bin "$name" && \
    cd "$name" && \
    cargo add $(__get_cargo_bin_crates) $(__get_cargo_lib_crates) 
}

function cargo_init_lib() {
    local name=${1:?name not set}
    cargo init --lib "$name" && \
    cd "$name" && \
    cargo add $(__get_cargo_lib_crates)
}
