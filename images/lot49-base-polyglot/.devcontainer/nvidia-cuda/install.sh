#!/bin/bash
set -e

# Ensure wget is installed
if ! type wget > /dev/null 2>&1; then
    apt-get update
    apt-get install -y --no-install-recommends wget
fi

# Detect architecture
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    CUDA_ARCH="x86_64"
elif [ "$ARCH" = "aarch64" ]; then
    CUDA_ARCH="sbsa"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

# Download and install CUDA keyring
wget "https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/${CUDA_ARCH}/cuda-keyring_1.1-1_all.deb"
dpkg -i cuda-keyring_1.1-1_all.deb

# Update package lists and install CUDA 13.1
apt-get update

# We only install the toolkit here. In a containerized environment, the drivers 
# are typically provided by the host via the NVIDIA Container Toolkit.
# Installing cuda-drivers explicitly pulls the latest (beta) drivers which we want to avoid.
apt-get -y install cuda-toolkit-13-1

# Clean up
rm cuda-keyring_1.1-1_all.deb
