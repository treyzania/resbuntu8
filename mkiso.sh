#!/bin/bash

workdir=$(realpath $1)

set -ex

# Rebuild the squashfs filesystem.
mksquashfs $workdir/rootfs $workdir/isodata/casper/filesystem.squashfs -b 1024k -comp xz -Xbcj x86 -e boot

# Actually package it together.
genisoimage -o resbuntu.iso $workdir/isodata
