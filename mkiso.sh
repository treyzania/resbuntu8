#!/bin/bash

set -ex

# Unmount the other filesystem.
sudo umount -f work/rootfs

# Actually package it together.
genisoimage -o resbuntu.iso work/isodata
