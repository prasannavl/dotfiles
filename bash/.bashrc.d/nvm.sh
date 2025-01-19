NVM_DIR="$HOME/.nvm"
if [[ ! -d "$NVM_DIR" ]]; then return 0; fi

export NVM_DIR
__source_file_if_exists "$NVM_DIR/nvm.sh"
__source_file_if_exists "$NVM_DIR/bash_completion"
