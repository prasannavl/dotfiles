__source_file_if_exists() {
	local file="${1?-file required}"
	if [[ -f "$file" ]]; then
		. "$file"
	fi
}

# mkdir -p and cd
mkcd() {
    mkdir -p "$@" && cd "$@"
}

# swap file name with an auto tmp file
mvx() {
    (
        set -Eeuo pipefail
        local suffix
        suffix="$(set +o pipefail && cat /dev/urandom | head -c12 | md5sum)"
        echo "mv: $1 -> $1.${suffix}"
        mv "$1" "$1.${suffix}"
        echo "mv: $2 -> $1"
        mv "$2" "$1"
        echo "mv $1.${suffix} -> $2"
        mv "$1.${suffix}" "$2"
    )
}
