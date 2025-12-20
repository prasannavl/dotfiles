#!/usr/bin/env bash

cat <<END | sudo tee /etc/sudoers.d/90_gpu_tweaks
pvl ALL = (ALL) NOPASSWD: /home/pvl/bin/amdgpu-reset.sh
END
