#!/usr/bin/env bash

cat <<END | sudo tee /etc/environment.d/10-amdgpu.conf
DRI_PRIME=pci-0000_65_00_0
__GLX_VENDOR_LIBRARY_NAME=mesa

END
