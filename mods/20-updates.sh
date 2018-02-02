#!/bin/bash

set -x

# We just do this a bunch of times so that we don't have to care about it.
# FIXME This doesn't really work as well as we want it to.
function dellocales () {
	locale-gen --purge en_US.UTF-8
}

# First, update things
dellocales
apt update

# First, make sure we get rid of stupid shit.
apt -y purge thunderbird
dpkg -P postfix

# Now, hold the Linux packages (since those won't work anyways) and then upgrade stuff.
apt-mark hold $(dpkg -l | awk '{ print $2 }' | grep -E '^linux')
apt-mark locale
apt -y upgrade

# Now install other packages for us.
dellocales
apt -y install $(grep -v "^#" /mnt/scripts/packages.list | tr -s '\n' ' ')

# And some cleanup.  This probably won't do all that much.
apt --fix-missing -f install
apt -y autoremove
dellocales
