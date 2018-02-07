#!/bin/sh

if [ $(id -u) != '0' ]; then
	echo 'must be root!'
	exit 1
fi

make unpack
./modify.sh work
./mkiso resbuntu.iso work
