#!/bin/bash

set -e

if [ $(id -u) != '0' ]; then
	echo 'must be root!'
	exit 1
fi

if [ "$1" == "" ]; then
	echo "usage: $0 <iso> <workdir>"
	exit 1
fi

iso=$(realpath $1)
workdir=$(realpath $2)

set -x

# Create the blank ISO we're creating and format it.
dd if=/dev/zero of=$iso bs=1M count=2048
layoutfile=layout.sfdisk
echo -e "g\nI\n$layoutfile\nw\n" | fdisk $iso
sync && sync

# Now create the partition devices and format them.
loopdev=$(losetup -f)
losetup -P $loopdev $iso
mkfs.fat $loopdev'p1'
mkfs.fat $loopdev'p2'

# Mount the EFI boot partition
efimnt=$workdir/mnt/efi
mkdir -p $efimnt
mount $loopdev'p1' $efimnt

# Compress the rootfs
if [ ! -f $workdir/root.squashfs -o "$3" == "--resquash" ]; then
	#mksquashfs $workdir/rootfs $workdir/root.squashfs -b 1024k -comp xz -Xbcj x86 -e boot
	mksquashfs $workdir/rootfs $workdir/root.squashfs -b 1024k -e boot
fi

# Copy the kernel and other important files for Casper to know what it's doing.
mkdir -p $efimnt/{casper,isolinux,install}
cp $workdir/isodata/casper/{vmlinuz.efi,initrd.lz} $efimnt/casper
cp $workdir/root.squashfs $efimnt/casper/filesystem.squashfs

# Manifest stuff for Casper.
sudo chroot $workdir/rootfs dpkg-query \
	-W \
	--showformat '${Package} ${Version}\n' \
	> $efimnt/casper/filesystem.manifest
cp -v $efimnt/casper/filesystem.manifest $efimnt/casper/filesystem.manifest-desktop
ignorepkgs='ubiquity ubiquity-frontend-gtk ubiquity-frontend-kde casper lupin-casper live-initramfs user-setup discover1 xresprobe os-prober libdebian-installer4'
for i in $ignorepkgs; do
	sed -i "/${i}/d" $efimnt/casper/filesystem.manifest-desktop
done
printf $(du -sx --block-size=1 $workdir/rootfs | cut -f1) > $efimnt/casper/filesystem.size
cp diskdefines $efimnt/README.diskdefines

# Setup GRUB, hopefully.
mkdir -p $efimnt/boot
grub-install \
	--target=x86_64-efi \
	--efi-directory=$efimnt \
	--boot-directory=$efimnt/boot \
	--removable \
	--uefi-secure-boot \
	$iso

# Insert our own GRUB config.
cat grub.cfg >> $efimnt/EFI/BOOT/grub.cfg

# More checksums and stuff.
touch $efimnt/ubuntu
mkdir -p $efimnt/.disk
pushd $efimnt/.disk
touch base_installable
echo "full_cd/single" > cd_type
echo "Resbuntu 8" > info
echo "http://rrc.neu.edu" > release_notes_url
cd ..
find . -type f -print0 | xargs -0 md5sum | grep -v "\.md5sum.txt" > md5sum.txt
popd

# Destroy the loopback device(s), unmounting stuff as necessary.
umount -f $efimnt
losetup -d $loopdev
