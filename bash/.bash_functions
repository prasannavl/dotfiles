# some functions

c() {
    bc -l <<< "$@"
}

wttr() {
    curl http://wttr.in/$@
}
