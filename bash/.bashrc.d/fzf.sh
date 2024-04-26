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
	__source_file_if_exists "/usr/share/bash-completion/completions/fzf"
elif [[ -d "/usr/share/fzf/shell" ]]; then
	# fedora / arch
	__source_file_if_exists "/usr/share/fzf/shell/key-bindings.bash"
	__source_file_if_exists "/usr/share/fzf/shell/completion.bash"
fi

# Custom completion commands

_fzf_setup_completion path f fzf mpv exa smplayer vim nvim
_fzf_setup_completion dir z d du tree ranger
#
unset _source_file_if_exists
