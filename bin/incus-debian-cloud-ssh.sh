#!/usr/bin/env bash
# Usage: ./setup.sh <container_name>

KEY_PATH=${KEY:-~/.ssh/id_ed25519.pub}
KEYDATA=$(cat "$KEY_PATH")

# Launch using the /cloud variant which supports cloud-init
incus launch images:debian/13/cloud "$1" -c security.nesting=true \
  -c cloud-init.user-data="#cloud-config
packages:
  - openssh-server
users:
  - name: pvl
    groups: sudo
    shell: /bin/bash
    sudo: 'ALL=(ALL) NOPASSWD:ALL'
    ssh_authorized_keys:
      - $KEYDATA"

echo "Waiting for cloud-init to finish..."
sleep 5s;
incus exec "$1" -- cloud-init status --wait
