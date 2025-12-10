# Add bin PATHs

# PATH order: unmanaged -> managed -> repo bins -> personal bin

_path_add_checked "$HOME/opt/bin"

# User-local bin
_path_add "$HOME/.local/bin"

_path_add_checked "$HOME/src/scripts/bin"
_path_add_checked "$HOME/src/scripts/sbin"

# Personal bin
_path_add "$HOME/bin"

export PATH
