#!/bin/sh
# set PATH for the case we are called via sudo or su root

PATH=/sbin:/usr/bin:/bin:/usr/bin:/usr/sbin

# create a tap
sudo tunctl -t tap0 -u mgross
sudo ip link set up dev tap0

# create the bridge
sudo brctl addbr br0
sudo brctl addif br0 tap0

# set the IP address and routing
sudo ip link set up dev br0
sudo ip addr add 10.1.1.1/24 dev br0
sudo ip route add 10.1.1.0/24 dev br0

