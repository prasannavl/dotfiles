#!/bin/bash

mkdir -p ~/data/nvme-stats

timestamp=$(date --iso-8601=s)
for device in /dev/nvme[0-9]*n1; do
    if [[ -e "$device" ]]; then
        device_name=$(basename "$device")
        echo "Gathering stats: $device..."
        sudo smartctl "$device" -x | tee ~/data/nvme-stats/"${timestamp}-${device_name}.txt"
    fi
done
