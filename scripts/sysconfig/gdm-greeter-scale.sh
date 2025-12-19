#!/usr/bin/env bash

cat <<END | sudo tee /etc/dconf/db/gdm.d/00-greeter-scale
[org/gnome/desktop/interface]
# Display scaling is uint32
scaling-factor=uint32 1
text-scaling-factor=1
END

sudo dconf update