#!/usr/bin/env bash
# Usage: ./setup.sh <container_name>

KEY_PATH=${KEY:-~/.ssh/id_ed25519.pub}
KEYDATA=$(cat "$KEY_PATH")

# Launch using the /cloud variant which supports cloud-init
incus launch images:debian/13 "$1" -c security.nesting=true;

incus exec "$1" -- bash -c "
  apt-get install -y openssh-server

  mkdir -p -m 700 /root/.ssh
  echo '$KEYDATA' > /root/.ssh/authorized_keys
  chmod 600 /root/.ssh/authorized_keys
  systemctl restart ssh
"
