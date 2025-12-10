# npm

npm_prefix="$HOME/.npm"
npm_bin="$npm_prefix/bin"

if [ "$(command -v npm)" ] || [ -d "$npm_bin" ]; then
	PATH="$npm_bin:$PATH"
	export NODE_PATH="$npm_prefix/lib/node_modules:$NODE_PATH"
fi

unset npm_bin
unset npm_prefix