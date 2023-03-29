# fasd opts

# Let's exit if not installed.
if [[ ! $(command -v fasd) ]]; then return 0; fi

# Make sure the cache directory is created.
# This has to be set in .fasdrc
fasd_cache_dir="$HOME/.cache/fasd"
[[ -d "$fasd_cache_dir" ]] || mkdir -p "$fasd_cache_dir"

# init
fasd_cache="$fasd_cache_dir/fasd-init-bash"
if [[ "$(command -v fasd)" -nt "$fasd_cache" || ! -s "$fasd_cache" ]]; then
    fasd --init posix-alias bash-hook bash-ccomp bash-ccomp-install >|"$fasd_cache"
fi

. "$fasd_cache"

