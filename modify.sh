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

# Apply the overlays for the root partition, which is really complicated to get the perms right.
mkdir -p $workdir/tempoverlay
cp -rf $overlaydir/root/* $workdir/tempoverlay
chown -R root:root $workdir/tempoverlay
cp -rf $workdir/tempoverlay/* $workdir/rootfs
rm -rf $workdir/tempoverlay

# Apply the overlays for the boot partition, which is simpler.
# TODO Change this to decide how it actually works.
#cp -rf $overlaydir/efi/* $workdir/isodata
#chown -R root:root $workdir/isodata

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
