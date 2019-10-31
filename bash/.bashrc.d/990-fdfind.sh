# fdfind

# Let's exit if not installed.
if [[ ! $(command -v fdfind) ]]; then return 0; fi

alias fd=fdfind
