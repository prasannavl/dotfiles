#!/bin/bash 

# some functions
c() {
    bc -l <<< "$@"
}

wttr() {
    curl http://wttr.in/$@
}

checked_alias() {
    local prog=${1?-cmd to check required}
    local alias_line=${2?-alias line required}
    shift 

    if [[ $(command -v ${prog}) ]]; then
        alias "${alias_line}"
    fi
}