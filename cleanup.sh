#!/bin/bash

if [ $(id -u) != "0" ]; then
	echo 'must be root!'
	exit 1
fi

set -x

kpartx -d /dev/loop* # this does more than it needs to
umount -f $1/mnt # usually not necessary
umount -f $1/rootfs/mnt/*
umount -f $1/rootfs
rm -rf $1
