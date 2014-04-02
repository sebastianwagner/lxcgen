#!/bin/sh

#https://wiki.debian.org/LXC/SimpleBridge

CMD_BRCTL=/sbin/brctl
CMD_IFCONFIG=/sbin/ifconfig
CMD_IPTABLES=/sbin/iptables
CMD_ROUTE=/sbin/route
NETWORK_BRIDGE_DEVICE_NAT=lxc-bridge-nat
HOST_NETDEVICE=eth0
PRIVATE_GW_NAT=192.168.100.1
PRIVATE_NETMASK=255.255.255.0

${CMD_BRCTL} addbr ${NETWORK_BRIDGE_DEVICE_NAT}
${CMD_BRCTL} setfd ${NETWORK_BRIDGE_DEVICE_NAT} 0
${CMD_IFCONFIG} ${NETWORK_BRIDGE_DEVICE_NAT} ${PRIVATE_GW_NAT} netmask ${PRIVATE_NETMASK} promisc up
${CMD_IPTABLES} -t nat -A POSTROUTING -o ${HOST_NETDEVICE} -j MASQUERADE
echo 1 > /proc/sys/net/ipv4/ip_forward
