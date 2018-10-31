# fzf

# Let's exit if fasd isn't installed.
if [ ! $(command -v fzf) ]; then return 0; fi

export FZF_DEFAULT_COMMAND='fd "" --follow --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Pick from git install, or package manager install
for x in $HOME/.fzf.bash /usr/share/fzf/shell/key-bindings.bash; do
if [ -f "$x" ]; then 
    source "$x"
    break
fi
done

complete -F _fzf_path_completion -o default -o bashdefault mpv
complete -F _fzf_dir_completion -o default -o bashdefault tree
complete -F _fzf_path_completion -o default -o bashdefault exa
complete -F _fzf_path_completion -o default -o bashdefault smplayer



