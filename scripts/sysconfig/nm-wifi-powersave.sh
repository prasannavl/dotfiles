#!/usr/bin/env bash

# WiFi power save mode values:
# 0 = disable power save
# 1 = enable power save (default)
# 2 = ignore/use driver default

cat <<END | sudo tee /etc/NetworkManager/conf.d/powersave.conf && sudo systemctl restart NetworkManager
[connection]
wifi.powersave = 2
END
