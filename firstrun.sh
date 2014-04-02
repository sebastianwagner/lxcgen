#!/bin/sh


#preparation
NAME="$1"
ROOTFS="/var/lib/lxc/${NAME}/rootfs/"
SSHDIR="/var/lib/lxc/${NAME}/rootfs/root/.ssh"
KEY=$(mktemp /tmp/id_ecdsa-XXXXXXXXX)
rm "${KEY}" #prevent keygen asking
PUBKEY="${KEY}.pub"
KNOWNHOSTS="${KEY}.known"
FULLIP="192.168.100.10"

#create
ssh-keygen -q -N "" -f "${KEY}" -t ecdsa -b 521 -C "${NAME}"
mkdir -p "${SSHDIR}"
cp "${PUBKEY}" \
 "${SSHDIR}/authorized_keys"

echo -n "${FULLIP} " >> "${KNOWNHOSTS}"
cat "${ROOTFS}/etc/ssh/ssh_host_ecdsa_key.pub" >> "${KNOWNHOSTS}"

ssh \
 -o UserKnownHostsFile="${KNOWNHOSTS}" \
 -i "${KEY}" \
 root@"${FULLIP}"

#cleanup
rm "${KEY}" "${PUBKEY}" "${KNOWNHOSTS}"


