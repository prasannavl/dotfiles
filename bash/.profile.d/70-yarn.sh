# yarn

# "$(yarn --offline global dir)/node_modules"
yarn_modules="$HOME/.config/yarn/global/node_modules"
yarn_bin="$HOME/.yarn/bin"

if [ "$(command -v yarn)" ] || [ -d "$yarn_modules" ] || [ -d "$yarn_bin" ]; then
	PATH="$yarn_bin:$PATH"
	export NODE_PATH="$yarn_modules:$NODE_PATH"
fi

unset yarn_modules
unset yarn_bin
