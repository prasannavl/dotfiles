# some functions

mkcd() {
    mkdir -p "$@" && cd "$@"
}

c() {
    bc <<<"scale=20;$@"
}

wttr() {
    curl http://wttr.in/$@
}

ip_external() {
    # curl ipecho.net/plain -s | xargs echo
    dig +short myip.opendns.com @resolver1.opendns.com
}

android_sdk_env() {
    android_sdk=$HOME/Android/Sdk
    if [[ -d "$android_sdk" ]]; then
        export ANDROID_HOME=$android_sdk
        export ANDROID_NDK_HOME=$ANDROID_HOME/ndk-bundle
        PATH="$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH"
    fi
    unset android_sdk
}
