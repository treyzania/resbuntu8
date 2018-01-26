#!/bin/bash

if [ $(id -u) != "0" ]; then
	echo 'must be root!'
	exit 1
fi

echo 'forcibly unmounting rootfs'
umount -f work/rootfs

echo 'deleting everything in workdir'
rm -rf work
