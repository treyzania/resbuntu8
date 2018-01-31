# Resbuntu 8

This is the project for Resbuntu 8, based on Xubuntu 17.04.

## Unpacking

You need to do two things in order to unpack the volume so that we can edit the
files in the way we need to: downloading and extracting.

You can do both in the same step with this:

```
sudo make unpack
```

(This will create the `work/` directory and leave the Xubuntu ISO as
`xubuntu.iso`, both in the current directory.

### Applying Modifications

This is simple, but we don't have a Makefile thing for it because of reasons.

```
sudo ./modify.sh work/
```

You can replace `work/` with whatever the work directory is, if it's changed.

This does two things: apply overlays and execute chrooted scripts

The overlays are found in `overlays/efi/` and `overlays/root/`.  The `efi`
overlays are applied to the GRUB partiton that lives directly in the ISO, and
the `root` overlays are applied to the tree extracted from the image at
`casper/filesystem.squashfs` in the ISO.

It also executes the scripts living in `mods/` in alphabetical order, with a
chroot set to the `work/rootfs/` directory, so it's somewhat like they're
running in the system that gets booted up later.  So you can install packages
here and do any modifications that you want to be persistent later.

## Repacking

To generate the modified ISO, it's also just one command.

```
make package
```

This will drop it into the current directory as `resbuntu.iso`.  You'll also
need to be able to use `sudo` for this to work.

**NOTE:** This doesn't actualy work yet.  I'm planning on having it actually
export a GPT-partitioned ISO that has a real ext4 filesystem on it instead of
this strange monstrosity that only exists for being able to burn onto CDs.

## Cleaning

Just do `make clean`.

