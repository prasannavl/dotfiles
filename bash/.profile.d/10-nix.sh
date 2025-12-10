# nix pkgs

if ! command -v nix-env >/dev/null 2>&1; then return 0; fi

if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
	. "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

export NIX_REMOTE=daemon
