#!/bin/bash

rm /etc/resolv.conf

echo 'Preconfiguring DNS settings...'
echo '# Temp DNS config for working until it gets overridden' >> /etc/resolv.conf
echo 'nameserver 127.0.0.53' >> /etc/resolv.conf
echo 'search rrc.local neu.edu' >> /etc/resolv.conf
