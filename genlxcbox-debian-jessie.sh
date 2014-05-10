#!/bin/sh

# genlxcbox-debian-jessie.sh


# lxc.conf
cat << EOF > lxc.conf
lxc.network.type = empty
EOF

# lxc-template
sed 's/,release:,clean/,release:,clean:,tarball:,auth-key/' \
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
