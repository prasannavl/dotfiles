# fzf

# Let's exit if not installed.
if [[ ! $(command -v fzf) ]]; then return 0; fi

# Custom config
find_command="$(which fd || which fdfind)"
if [[ -n "$find_command" ]]; then
    export FZF_DEFAULT_COMMAND="${find_command} --follow --hidden --color=always"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_DEFAULT_OPTS="--ansi"
fi

# Source the required scripts for default completion

__source_file_if_exists() {
    local file="${1?-file required}"
    if [[ -f "$file" ]]; then
     . "$file"
    fi
}

if [[ -f $HOME/.fzf.bash ]]; then
    # git version, prioritize this and skip everything else
    # note, the line added due to install script
    # can be safely removed.
    . $HOME/.fzf.bash
elif [[ -f "/etc/debian_version" ]]; then 
    # debian pkg version
    __source_file_if_exists "/usr/share/doc/fzf/examples/key-bindings.bash"
    __source_file_if_exists "/usr/share/doc/fzf/examples/completion.bash"
elif [[ -d "/usr/share/fzf/shell" ]]; then
    # fedora / arch
    __source_file_if_exists "/usr/share/fzf/shell/key-bindings.bash"
    __source_file_if_exists "/usr/share/fzf/shell/completion.bash"
fi

# Custom completion commands

path_cmds=(f mpv exa smplayer)
for cmd in "${path_cmds[@]}"; do 
    if [[ $(command -v "${cmd}") ]]; then
        complete -F _fzf_path_completion -o default -o bashdefault "${cmd}"; 
    fi
done

dir_cmds=(z d tree)
for cmd in "${dir_cmds[@]}"; do 
    if [[ $(command -v "${cmd}") ]]; then 
        complete -F _fzf_dir_completion -o default -o bashdefault "${cmd}"; 
    fi
done

unset _source_file_if_exists

