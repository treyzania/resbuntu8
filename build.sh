#!/bin/sh

if [ $(id -u) != '0' ]; then
	echo 'must be root!'
	exit 1
fi

workdir=work
iso=$workdir/xubuntu.iso

set -e
mkdir -p $workdir

if [ ! -e $iso ]; then
	./dl.sh $iso
fi

./unpack.sh $iso $workdir
./modify.sh $workdir
./mkiso.sh resbuntu.iso $workdir
