# fzf

export FZF_DEFAULT_COMMAND='fd "" --follow --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

if [ -f ~/.fzf.bash ]; then 
    # git installation
    source ~/.fzf.bash
elif [ -f /usr/share/fzf/shell/key-bindings.bash ]; then
    # package manager installation
    source /usr/share/fzf/shell/key-bindings.bash
fi

complete -F _fzf_path_completion -o default -o bashdefault mpv
complete -F _fzf_dir_completion -o default -o bashdefault tree
complete -F _fzf_path_completion -o default -o bashdefault exa
complete -F _fzf_path_completion -o default -o bashdefault smplayer
