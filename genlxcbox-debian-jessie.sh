#!/bin/sh

# genlxcbox-debian-jessie.sh


# lxc.conf
cat << EOF > lxc.conf
lxc.network.type = empty
EOF

# lxc-template
sed -e 's/,release:,clean/,release:,clean:,tarball:,auth-key/' \
 -e '147i\    #setup vagrant user' \
 -e 's/ dhcp/ manual/' \
 -e '147i\    chroot $rootfs adduser --disabled-password --gecos Vagrant vagrant' \
 -e '147i\    chroot $rootfs adduser vagrant sudo' \
 -e '147i\    chroot --userspec=vagrant:vagrant $rootfs mkdir -p /home/vagrant/.ssh/' \
 -e '147i\    echo "vagrant:vagrant" | chroot $rootfs chpasswd' \
 -e '147i\    echo "'"$(cat /usr/share/vagrant/keys/vagrant.pub)"'" | sudo chroot --userspec=vagrant:vagrant $rootfs tee -a "/home/vagrant/.ssh/authorized_keys"' \
 -e '147i\ ' \
 -e '170i sudo,\\' \
 /usr/share/lxc/templates/lxc-debian \
 > lxc-template

# metadata.json
cat << EOF > metadata.json
{
  "provider": "lxc",
  "version":  "3",
  "built-on": "$(date)",
  "template-opts": {
    "--release": "jessie"
  }
}
EOF

# rootfs.tar.gz
mkdir rootfs \
 && tar -cf rootfs.tar.gz rootfs \
 && rmdir rootfs

# jessie.box
tar -czf jessie.box ./

# install
# scp jessie.box webserver:www/
# vagrant box remove jessie lxc
# vagrant box add jessie http://webserver.local/jessie.box --provider lxc
