#!/bin/bash

# Unmount these.
losetup -D

# Now unmount these.
for m in $(mount | grep $(pwd) | awk '{ print $1 }'); do
	umount -f $m
done

# Do it again, just in case.
losetup -D
