#!/usr/bin/env bash
# Usage: ./setup.sh <container_name>

KEY=${KEY:-~/.ssh/id_ed25519.pub}
KEYDATA=$(cat "$KEY")

incus launch images:nixos/25.11 "$1" -c security.nesting=true; 
sleep 5s;
incus exec "$1" -- bash -l -c "
echo '{ ... }: {
  services.openssh.enable = true;
  users.users.pvl = {
    isNormalUser = true;
    extraGroups = [ \"wheel\" ];
    openssh.authorizedKeys.keys = [ \"$KEYDATA\" ];
  };
  security.sudo.wheelNeedsPassword = false;
  nix.settings.trusted-users = [ \"pvl\" ];
}' > /etc/nixos/ssh.nix

sed -i 's|./incus.nix|./incus.nix ./ssh.nix|' /etc/nixos/configuration.nix
nixos-rebuild switch
"