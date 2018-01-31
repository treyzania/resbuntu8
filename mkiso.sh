#!/bin/bash

workdir=$(realpath $1)

set -ex

# Unmount the other filesystem.
sudo umount -f work/rootfs

# Actually package it together.
genisoimage -o resbuntu.iso work/isodata
