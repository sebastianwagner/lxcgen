#!/bin/sh

NAME="$1"
sudo lxc-start \
 -n "${NAME}" \
 -d &
sleep 1 \
&& sudo lxc-console \
 -e '^e' \
 -n "${NAME}"
