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

mkdir -p $workdir
cd $workdir
mkdir -p mnt isodata rootfs initrd
rootfspath=$(realpath rootfs)

# Mount and extract data.
mount -t iso9660 -o loop,ro $iso mnt
cp -r mnt/* isodata

# Unmount
umount mnt
rmdir mnt

# Extract the squashfs
unsquashfs -f -d $rootfspath isodata/casper/filesystem.squashfs

# Extract the initrd
pushd $workdir/initrd
lzma -dc -S .lz $workdir/isodata/casper/initrd.lz | cpio -id
popd
