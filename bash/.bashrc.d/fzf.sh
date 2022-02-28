# fzf

# Let's exit if fasd isn't installed.
if [[ ! $(command -v fzf) ]]; then return 0; fi

# Custom config
find_command="$(command -v fd || command -v fdfind)"
if [[ -n "$find_command" ]]; then
    export FZF_DEFAULT_COMMAND="${find_command} --follow --hidden --exclude .git --color=always"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_DEFAULT_OPTS="--ansi"
fi

# Source the required scripts for default completion

if [[ -f $HOME/.fzf.bash ]]; then
    # git version, prioritize this and skip everything else
    # note, the line added due to install script
    # can be safely removed.
    . $HOME/.fzf.bash
elif [[ -f "/etc/debian_version" ]]; then 
    # debian pkg version
    . /usr/share/doc/fzf/examples/key-bindings.bash
    . /usr/share/doc/fzf/examples/completion.bash
elif [[ -d "/usr/share/fzf/shell" ]]; then
    # fedora / arch
    . /usr/share/fzf/shell/key-bindings.bash
    . /usr/share/fzf/shell/completion.bash
fi

# Custom completion commands

path_cmds=(f mpv exa smplayer)
for cmd in ${path_cmds[@]}; do 
    if [[ $(command -v ${cmd}) ]]; then
        complete -F _fzf_path_completion -o default -o bashdefault ${cmd}; 
    fi
done

dir_cmds=(z d tree)
for cmd in ${dir_cmds[@]}; do 
    if [[ $(command -v ${cmd}) ]]; then 
        complete -F _fzf_dir_completion -o default -o bashdefault ${cmd}; 
    fi
done
