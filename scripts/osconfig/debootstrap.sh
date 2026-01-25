set -Eeuo pipefail

vars() {
    BOOT_DEVICE=/dev/nvme0n1p1
    LUKS_DEVICE=/dev/nvme0n1p2
    CRYPT_NAME=crypt-root
    BTRFS_DEVICE=/dev/mapper/${CRYPT_NAME}
    
    HOST_MOUNTPOINT=/mnt
    DEBIAN_MIRROR=https://deb.debian.org/debian
    DEBIAN_SUITE=trixie

    SUBVOL_ROOT=deb
    SUBVOLS=(home etc var_cache var_log var_tmp)
    EFI_ENTRY_NAME=debian

    TARGET_ROOT=${HOST_MOUNTPOINT}/@${SUBVOL_ROOT}
}

mount_crypt() {
    sudo cryptsetup open $LUKS_DEVICE $CRYPT_NAME
}

unmount_crypt() {
    sudo cryptsetup close $CRYPT_NAME
}

mount_toplevel() {
    sudo mount -o subvolid=5 $BTRFS_DEVICE $HOST_MOUNTPOINT
}

unmount_toplevel() {
    sudo umount $HOST_MOUNTPOINT
}

create_subvol_root() {
    sudo btrfs subvolume create $TARGET_ROOT
}

delete_subvol_root() {
    sudo btrfs subvolume delete $TARGET_ROOT
}

mount_subvol_root() {
    sudo mount -o subvol=@$SUBVOL_ROOT,compress=zstd $BTRFS_DEVICE $TARGET_ROOT 
}

unmount_subvol_root() {
    sudo umount -R $TARGET_ROOT
}

mount_boot_device() {
    sudo mkdir -p $TARGET_ROOT/boot/efi
    sudo mount $BOOT_DEVICE $TARGET_ROOT/boot/efi
}

unmount_boot_device() {
    sudo umount -R $TARGET_ROOT/boot/efi
}

create_subvols() {
    for x in ${SUBVOLS[@]}; do
        subvol=@${SUBVOL_ROOT}_$x
        sudo btrfs subvolume create $HOST_MOUNTPOINT/$subvol
    done
}

delete_subvols() {
    for x in ${SUBVOLS[@]}; do
        subvol=@${SUBVOL_ROOT}_$x
        sudo btrfs subvolume delete $HOST_MOUNTPOINT/$subvol
    done
}

mount_subvols() {
    for x in ${SUBVOLS[@]}; do
        subvol=@${SUBVOL_ROOT}_$x
        target_dir=${TARGET_ROOT}/${x//_//}
        sudo mkdir -p $target_dir
        sudo mount -o subvol=$subvol,compress=zstd $BTRFS_DEVICE $target_dir
    done
}

unmount_subvols() {
    for x in ${SUBVOLS[@]}; do
        target_dir=${TARGET_ROOT}/${x//_//}
        sudo umount -R $target_dir
    done
}

debootstrap_install() {
    sudo debootstrap --arch amd64 --components=main,contrib,non-free,non-free-firmware \
        $DEBIAN_SUITE $TARGET_ROOT $DEBIAN_MIRROR
}

chroot_debootstrap() {
    sudo mount --bind /dev  $TARGET_ROOT/dev
    sudo mount --bind /proc $TARGET_ROOT/proc
    sudo mount --bind /sys  $TARGET_ROOT/sys
    sudo chroot $TARGET_ROOT /bin/bash
}

unmount_debootstrap() {
    sudo umount $TARGET_ROOT/dev
    sudo umount $TARGET_ROOT/proc
    sudo umount $TARGET_ROOT/sys
}

unmount_all() {
    # unmount_debootstrap
    # unmount_subvols
    unmount_boot_device
    unmount_subvol_root
    unmount_toplevel
    unmount_crypt
}

delete_all() {
    delete_subvols
    delete_subvol_root
}

apt_install() {
    apt update
    apt install -y ca-certificates locales tzdata keyboard-configuration sudo

    dpkg-reconfigure locales
    dpkg-reconfigure tzdata
    dpkg-reconfigure keyboard-configuration

    apt install -y firmware-linux \
        firmware-linux-nonfree \
        firmware-iwlwifi \
        firmware-amd-graphics \
        firmware-misc-nonfree

    apt install -y linux-image-amd64 linux-headers-amd64
    apt install -y systemd-boot systemd-resolved network-manager 
    apt install -y dialog wget curl lsb-release btrfs-progs efibootmgr
}

setup_systemd_boot() {
    UUID="$(cryptsetup luksUUID $LUKS_DEVICE)" && install -d /boot/efi/loader/entries && \
    cat <<END | tee /boot/efi/loader/entries/${EFI_ENTRY_NAME}.conf
title   ${EFI_ENTRY_NAME}
linux   /EFI/${EFI_ENTRY_NAME}/linux
initrd  /EFI/${EFI_ENTRY_NAME}/initrd.img
options rd.luks.name=%s=$CRYPT_NAME root=${BTRFS_DEVICE} rootflags=subvol=@${SUBVOL_ROOT},compress=zstd:3 rw quiet "$UUID" 
END
}

main() {
    vars
    if [ "$#" -ne 0 ]; then
        "$@"
    else
        run
    fi
}

run() {
    mount_crypt
    mount_toplevel
    # create_subvol_root
    # mount_subvol_root
    # mount_boot_device
    # create_subvols
    # mount_subvols
    # debootstrap_install
    # chroot_debootstrap
    # unmount_all
}

main "$@"

