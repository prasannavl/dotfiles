#!/usr/bin/env bash

cat <<END | sudo tee /etc/modprobe.d/00-amd-first.conf
# Ensure AMD KMS binds before NVIDIA
softdep nvidia pre: amdgpu
softdep nvidia_drm pre: amdgpu
softdep nvidia_modeset pre: amdgpu

END
