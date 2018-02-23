#!/bin/bash

workdir=$(realpath $1)
scriptsdir=$(realpath mods)
overlaydir=$(realpath overlays)

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

# Apply some overlay systems.
function apply_overlay() {
	mkdir -p $workdir/$1.tmpoverlay
	cp -rf $overlaydir/$1/* $workdir/$1.tmpoverlay
	chown -R root:root $workdir/$1.tmpoverlay
	cp -rf $workdir/$1.tmpoverlay/* $workdir/$2
	rm -rf $workdir/$1.tmpoverlay
}
apply_overlay root rootfs      # Root filesystem.
apply_overlay initramfs initrd # The initramfs, where casper lives.

# Set up the script execution
# (This used to be a bind mount but that was breaking things sometimes.)
binddir=rootfs/mnt/scripts
mkdir -p $binddir
cp -r $scriptsdir/* $binddir

# Go hide in the fs dir
pushd rootfs

# Display what we're running
chroot . ls -l /mnt/scripts

# Actually execute things
set +e
for f in $(find mnt/scripts -type f -executable); do
	chroot . $f
	# TODO Make it report mod failures.
done
set -e

# Escape from the fs dir
popd

# Remove the scripts
rm -rf $binddir
