#!/bin/bash

set -e

if [ $(id -u) != '0' ]; then
	echo 'must be root!'
	exit 1
fi

if [ "$1" == "" ]; then
	echo "usage: $0 <iso>"
	exit 1
fi

iso=$(realpath $1)

set -x

mkdir -p work
cd work

mkdir -p mnt
mkdir -p isodata
mkdir -p rootfs

# Mount and extract data.
mount -t iso9660 -o loop,ro $iso mnt
cp -r mnt/* isodata

# Unmount
umount mnt
rmdir mnt

# Now mount the rootfs
mount -t squashfs -o rw isodata/casper/filesystem.squashfs rootfs