#!/bin/bash

set -e

if [ $(id -u) != '0' ]; then
	echo 'must be root!'
	exit 1
fi

if [ "$1" == "" ]; then
	echo "usage: $0 <workdir>"
	exit 1
fi

workdir=$(realpath $1)

set -x

mkdir -p $workdir
cd $workdir
mkdir -p mnt isodata rootfs initrd
rootfspath=$(realpath rootfs)

chroot $rootfspath bash
