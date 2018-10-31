
alias cls='printf "\ec"' # \033
alias la='ls -AlhF --group-directories-first'
alias l='ls -CF'

if [ $(command -v vimx) ]; then
    alias vim='vimx'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias cat-highlight='highlight -O ansi --force'
alias cat-source-highlight='source-highlight -f esc -o STDOUT -i'

