#!/usr/bin/env bash

cat <<END | sudo tee /etc/modprobe.d/nvidia.conf
options nvidia-drm modeset=1 fbdev=1
options nvidia NVreg_PreserveVideoMemoryAllocations=1
options nvidia NVreg_DynamicPowerManagement=0x02
options nvidia NVreg_TemporaryFilePath=/var/tmp
options nvidia NVreg_EnableGpuFirmware=1

END
