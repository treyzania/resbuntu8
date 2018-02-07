#!/bin/bash

workdir=$(realpath $1)

set -ex

# Rebuild the squashfs filesystem.
rootimgpath=$workdir/isodata/casper/filesystem.squashfs
rm $rootimgpath
mksquashfs $workdir/rootfs $rootimgpath -b 1024k -comp xz -Xbcj x86 -e boot

# Actually package it together.
genisoimage -o resbuntu.iso $workdir/isodata
