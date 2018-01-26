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

mkdir -p work
cd work

mkdir -p mnt
mkdir -p isodata
mkdir -p rootfs

echo 'mounting iso'
mount -t iso9660 -o loop,ro $iso mnt

echo 'extracting isodata'
cp -r mnt/* isodata

echo 'unmounting iso'
umount mnt
rmdir mnt

echo 'mounting internal squashfs'
mount isodata/casper/filesystem.squashfs rootfs

echo 'Done!'
