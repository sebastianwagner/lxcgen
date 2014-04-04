#!/bin/sh

#preparation
NAME="$1"
TMP=$(mktemp --suffix=.conf lxc-XXXXXXXXX)
cp ./network.conf "${TMP}"
IP=$(echo "${NAME}" | tr -d '[:alpha:]')
sed -i 's/192\.168\.100\.13/192.168.100.'"${IP}"'/' "${TMP}"

cat ./capabilities.conf >> "${TMP}"

#create
SUITE=wheezy \
MIRROR=http://ftp.de.debian.org/debian \
lxc-create \
 -n "${NAME}" \
 -t debian \
 -f "${TMP}"

#adjust
./setnetwork.sh "${NAME}"

#cleanup
rm "${TMP}"

#stats
echo "sudo ./rundebian.sh ${NAME} #to run instance"
echo "sudo lxc-destroy -n ${NAME} #to destroy instance"
