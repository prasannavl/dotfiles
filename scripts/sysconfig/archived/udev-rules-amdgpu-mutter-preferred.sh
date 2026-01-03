#!/usr/bin/env bash

cat <<END | sudo tee /etc/udev/rules.d/80-amdgpu-mutter-preferred.rules
SUBSYSTEM=="drm", ENV{DEVTYPE}=="drm_minor", ENV{DEVNAME}=="/dev/dri/card[0-9]", SUBSYSTEMS=="pci", ATTRS{vendor}=="0x1002", ATTRS{device}=="0x150e", TAG+="mutter-device-preferred-primary"
ENV{DEVNAME}=="/dev/dri/card1", TAG+="mutter-device-preferred-primary"
END
