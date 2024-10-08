# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).

if [[ ! -f "/etc/debian_version" ]]; then return; fi

if ! shopt -oq posix; then
	# /etc/bash_completion is source link to second file below on debian
	if [[ -f /etc/bash_completion ]]; then
		. /etc/bash_completion
	elif [[ -f /usr/share/bash-completion/bash_completion ]]; then
		. /usr/share/bash-completion/bash_completion
	fi
fi
