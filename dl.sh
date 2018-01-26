#!/bin/sh

url='http://mirror.us.leaseweb.net/ubuntu-cdimage/xubuntu/releases/17.10/release/xubuntu-17.10.1-desktop-amd64.iso'
curl -# -o $1 $url
