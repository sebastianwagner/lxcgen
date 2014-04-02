#!/bin/sh

NAME="$1"

sed -i \
 's/dhcp/manual/' \
 "/var/lib/lxc/${NAME}/rootfs/etc/network/interfaces"
