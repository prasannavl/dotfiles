# fzf

# Let's exit if fasd isn't installed.
if [[ ! $(command -v fzf) ]]; then return 0; fi

if [[ $(command -v fdfind) ]]; then
    export FZF_DEFAULT_COMMAND='fdfind --follow --hidden --exclude .git --color=always'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_DEFAULT_OPTS="--ansi"
fi

# Pick from git install, or package manager install
declare -a files
files=(\
    $HOME/.fzf.bash \
    /usr/share/fzf/shell/key-bindings.bash \
    /usr/share/doc/fzf/examples/key-bindings.bash\
    )
for x in ${files[@]}; do
    if [[ -f "$x" ]]; then
        source "$x"
        break
    fi
done

if [[ $(command -v mpv) ]]; then complete -F _fzf_path_completion -o default -o bashdefault mpv; fi
if [[ $(command -v tree) ]]; then complete -F _fzf_dir_completion -o default -o bashdefault tree; fi
if [[ $(command -v exa) ]]; then complete -F _fzf_path_completion -o default -o bashdefault exa; fi
if [[ $(command -v smplayer) ]]; then complete -F _fzf_path_completion -o default -o bashdefault smplayer; fi
