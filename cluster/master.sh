#!/bin/bash
workDir=$(pwd)
# shellcheck disable=SC1090
source "${workDir}/docker.sh"
# shellcheck disable=SC1090
source "${workDir}/criO.sh"
# shellcheck disable=SC1090
source "${workDir}/containerd.sh"
# shellcheck disable=SC1090
source "${workDir}/kubeTools.sh"
kubeadm config images pull
kubeadm init --pod-network-cidr 10.0.0.1