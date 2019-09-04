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