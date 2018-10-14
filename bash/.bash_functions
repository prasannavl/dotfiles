# some functions

function mkcd() {
    mkdir -p "$@" && cd "$@"
}

function wttr() {
    curl http://wttr.in/$@
}

