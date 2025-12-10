# go-lang

gopath_dir="$HOME/src/go"
if [ "$(command -v go)" ] || [ -d "$gopath_dir" ]; then
	export GOPATH="$gopath_dir"
	mkdir -p "$gopath_dir" || true
	PATH="$gopath_dir/bin:$PATH"
fi
unset gopath_dir
