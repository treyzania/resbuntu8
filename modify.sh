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
cp -rf $overlaydir/efi/* $workdir/isodata
chown -R root:root $workdir/isodata

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
sync && sync
rmdir $binddir
