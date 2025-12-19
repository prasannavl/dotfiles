#!/usr/bin/env bash

cat <<END | sudo tee /etc/NetworkManager/conf.d/iwd.conf && sudo systemctl restart NetworkManager
[device]
wifi.backend=iwd
wifi.iwd.autoconnect=yes
END
