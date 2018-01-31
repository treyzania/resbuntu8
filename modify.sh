#!/bin/bash

workdir=$(realpath $1)
scriptsdir=$(realpath scripts)
overlaydir=$(realpath overlay)

if [ "$(id -u)" != "0" ]; then
	echo 'error: must be root!'
	exit 1
fi

if [ ! -d $workdir ]; then
	echo 'error: workdir does not exist?'
	exit 1
fi

set -ex

cd $workdir

# Copy the overlay into the fs
cp -r $overlaydir/* $workdir/rootfs

# Set up the script execution
binddir=rootfs/mnt/scripts
mkdir -p $binddir
mount --bind $scriptsdir $binddir

# Go hide in the fs dir
pushd rootfs

# Display what we're running
chroot . ls -l /mnt/scripts

# Actually execute things
set +e
for f in mnt/scripts/*; do
	chroot . $f
done
set -e

# Escape from the fs dir
popd

# Unmount the scripts
umount -f $binddir
rmdir $binddir
