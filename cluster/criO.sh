#!/bin/bash

modprobe overlay
modprobe br_netfilter

# Setup required sysctl params, these persist across reboots.
cat > /etc/sysctl.d/99-kubernetes-cri.conf <<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sysctl --system

# Install prerequisites
apt-get update
apt-get install -y software-properties-common

add-apt-repository ppa:projectatomic/ppa -y
apt-get update

# Install CRI-O
apt-get install -y cri-o-1.13

systemctl start crio