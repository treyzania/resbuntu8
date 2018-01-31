#!/bin/bash

if [ $(id -u) != "0" ]; then
	echo 'must be root!'
	exit 1
fi

set -ex

umount -f $1/rootfs
rm -rf $1
