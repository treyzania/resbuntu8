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
workdir=$(realpath $2)

set -x

if [ -f $workdir ]; then
	echo 'error: it looks like we already unpacked the ISO, try cleaning?'
	exit 1
fi

mkdir -p $workdir
cd $workdir
mkdir -p mnt isodata rootfs
rootfspath=$(realpath rootfs)

# Mount and extract data.
mount -t iso9660 -o loop,ro $iso mnt
cp -r mnt/* isodata

# Unmount
umount mnt
rmdir mnt

# Extract the squashfs
unsquashfs -f -d $rootfspath isodata/casper/filesystem.squashfs
