__source_file_if_exists() {
	local file="${1?-file required}"
	if [[ -f "$file" ]]; then
		. "$file"
	fi
}
