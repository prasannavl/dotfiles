# enable color support of ls and also add handy aliases
# source: Debian

if [[ -x /usr/bin/dircolors ]]; then
    [[ -r $HOME/.dircolors ]] && eval "$(dircolors -b $HOME/.dircolors)" || eval "$(dircolors -b)"
    export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
fi
