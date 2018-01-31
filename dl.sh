#!/bin/bash

if [ "$1" == "" ]; then
	echo "usage: $0 <iso>"
	exit 1
fi

if [ -f $1 ]; then
	echo 'error: file exists'
	exit 1
fi

url='http://mirror.us.leaseweb.net/ubuntu-cdimage/xubuntu/releases/17.10/release/xubuntu-17.10.1-desktop-amd64.iso'
curl -# -o $1 $url
