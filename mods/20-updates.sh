#!/bin/bash

set -x

# First, update things
apt update

# Now, hold the Linux packages (since those won't work anyways) and then upgrade stuff.
apt-mark hold $(dpkg -l | awk '{ print $2 }' | grep -E '^linux')
apt -y upgrade

# Now install other packages for us.
apt -y install $(grep -v "^#" /mnt/packages.list | tr -s '\n' ' ')

# And some cleanup.
apy --fix-missing -f install
apt -y autoremove
