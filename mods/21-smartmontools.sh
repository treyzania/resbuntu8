#!/bin/bash

set -ex

# Setup some space for us.
mkdir -p /tmp/smartmontools
cd /tmp/smartmontools

# Extract stuff
apt download smartmontools
ar x *.deb
unxz 'data.tar.xz'
tar -xvf 'data.tar'

# Now move things around
cp -r var/* /var
cp -r usr/* /usr
cp -r etc/* /etc
