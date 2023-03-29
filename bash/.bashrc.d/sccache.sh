# sccache for rustc

# Let's exit if not installed.
if [[ ! $(command -v sccache) ]]; then return 0; fi

export RUSTC_WRAPPER=sccache
