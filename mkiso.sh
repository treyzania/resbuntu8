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

# Now create the partition devices and format them.
# TODO Make this horrible awk stuff better.
# TODO Make this configure GRUB, also.
loops=$(kpartx -a -s -v $iso | awk '{ print $3 }' | sed 's/\n/ /g')
mksquashfs $workdir/rootfs $workdir/root.squashfs -b 1024k -comp xz -Xbcj x86 -e boot
dd if=$workdir/root.squashfs of=/dev/mapper/$(echo $loops | awk '{ print $2 }'
mkfs.fat /dev/mapper/$(echo $loops | awk '{ print $3 }')

# Destroy the loopback device(s).
kpartx -d $iso
