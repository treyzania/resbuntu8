#!/bin/bash

set -e

if [ $(id -u) != '0' ]; then
	echo 'must be root!'
	exit 1
fi

if [ "$1" == "" ]; then
	echo "usage: $0 <iso> <workdir>"
	exit 1
fi

iso=$(realpath $1)
workdir=$(realpath $2)

set -x

# Create the blank ISO we're creating and format it.
dd if=/dev/zero of=$iso bs=1M count=2048
layoutfile=layout.sfdisk
echo -e "g\nI\n$layoutfile\nw\n" | fdisk $iso
sync && sync

# Now create the partition devices and format them.
loopdev=$(losetup -f)
losetup -P $loopdev $iso
#mksquashfs $workdir/rootfs $workdir/root.squashfs -b 1024k -comp xz -Xbcj x86 -e boot
if [ ! -f $workdir/root.squashfs -o "$3" == "--resquash" ]; then
	mksquashfs $workdir/rootfs $workdir/root.squashfs -b 1024k -e boot
fi
dd if=$workdir/root.squashfs of=$loopdev'p2'
mkfs.fat $loopdev'p1'
mkfs.fat $loopdev'p3'

# Setup grub, hopefully.
efimnt=$workdir/mnt/efi
mkdir -p $efimnt
mount $loopdev'p1' $efimnt
mkdir -p $efimnt/boot
grub-install --target=x86_64-efi --efi-directory=$efimnt --boot-directory=$efimnt/boot --removable --uefi-secure-boot $iso

# Also copy the kernel and initrd into the GRUB stuff.
mkdir $efimnt/kernel
cp $workdir/isodata/casper/{vmlinuz.efi,initrd.lz} $efimnt/kernel

# Insert our own GRUB config.
cat grub.cfg >> $efimnt/EFI/BOOT/grub.cfg

# Destroy the loopback device(s), unmounting stuff as necessary.
umount -f $efimnt
losetup -d $loopdev
