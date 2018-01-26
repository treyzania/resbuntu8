# Resbuntu 17

This is the project for Resbuntu 17, based on Xubuntu 17.04.

## Unpacking

You need to do two things in order to unpack the volume so that we can edit the
files in the way we need to: downloading and extracting.

You can do both in the same step with this:

```
make unpack
```

This will download the Xubuntu ISO and unpack it into the work/rootfs
directory.  Unfortunately you'll also need to be able to `sudo` to get this
to work.

(This will create the `work/` directory and leave the Xubuntu ISO as
`xubuntu.iso`, both in the current directory.

## Repacking

To generate the modified ISO, it's also just one command.

```
make package
```

This will drop it into the current directory as `resbuntu.iso`.  You'll also
need to be able to use `sudo` for this to work.

## Cleaning

As always, you can clean up everything with `make clean`, but you might need
to use `sudo` for this as well as we're messing around with mounts.
