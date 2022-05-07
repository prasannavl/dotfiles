alias cls='printf "\ec"' # \033

alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ll='ls -lh --color=auto'
alias la='ls -AlhF --group-directories-first --color=auto'
alias l='ls -CFh --color=auto'
alias l.='ls -dh .* --color=auto'
alias lt='ls -lth --color=auto'

alias xzgrep='xzgrep --color=auto'
alias xzegrep='xzegrep --color=auto'
alias xzfgrep='xzfgrep --color=auto'
alias zgrep='zgrep --color=auto'
alias zfgrep='zfgrep --color=auto'
alias zegrep='zegrep --color=auto'

checked_alias tree t='tree -ah'
checked_alias diff diffy='diff -y --color'
checked_alias pgrep pgrepf='pgrep -af'
checked_alias xdg-open o=xdg-open
checked_alias ranger r=ranger
checked_alias iostat iostatw='iostat -xdszh 1'
checked_alias iotop iotop="sudo iotop"
checked_alias lxc lxc="sudo lxc"
checked_alias podman docker="podman"

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
checked_alias notify_send alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

