#!/usr/bin/env bash

cat <<END | sudo tee /etc/default/grub.d/20-resume.cfg
GRUB_CMDLINE_LINUX_DEFAULT="\$GRUB_CMDLINE_LINUX_DEFAULT resume=/dev/mapper/vg0-home resume_offset=38619136"
END
