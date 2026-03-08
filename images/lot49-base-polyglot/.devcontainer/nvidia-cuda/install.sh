#!/bin/bash
set -e

# Ensure wget is installed
if ! type wget > /dev/null 2>&1; then
    apt-get update
    apt-get install -y --no-install-recommends wget
fi

# Download and install CUDA keyring
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
dpkg -i cuda-keyring_1.1-1_all.deb

# Update package lists and install CUDA 13
apt-get update
apt-get -y install cuda-13

# Clean up
rm cuda-keyring_1.1-1_all.deb
