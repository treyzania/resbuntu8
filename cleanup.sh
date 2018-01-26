#!/bin/bash

if [ $(id -u) != "0" ]; then
	echo 'must be root!'
	exit 1
fi

umount -f work/rootfs
rm -rf work
