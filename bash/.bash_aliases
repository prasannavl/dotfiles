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

alias xzgrep='xzgrep --color=auto'
alias xzegrep='xzegrep --color=auto'
alias xzfgrep='xzfgrep --color=auto'
alias zgrep='zgrep --color=auto'
alias zfgrep='zfgrep --color=auto'
alias zegrep='zegrep --color=auto'

alias tree='tree -ah'
alias diffy='diff -y --color'
alias iostatw='iostat -xdszh 1'
alias free='free -h'
alias df='df -h'
alias du='du -h'
alias pg='pgrep -af'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias cat-highlight='highlight -O ansi --force'
alias cat-source-highlight='source-highlight -f esc -o STDOUT -i'

alias xo=xdg-open
alias docker="sudo docker"
alias iotop="sudo iotop"

sublime_text="/opt/sublime_text/sublime_text"
if [ -x "$sublime_text" ]; then
    alias sublime="$sublime_text"
fi
unset sublime_text

