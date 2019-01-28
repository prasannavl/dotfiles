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
    if [ -d "$android_sdk" ]; then
        export ANDROID_HOME=$android_sdk
        export ANDROID_NDK_HOME=$ANDROID_HOME/ndk-bundle
        PATH="$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH"
    fi
    unset android_sdk
}
