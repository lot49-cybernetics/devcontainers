#!/bin/bash

set -e

# Determine the architecture of the Linux system
ARCH=$(uname -m)

# Sets the exact version to install, with a default and override
VERSION=${VERSION:-"8.5.1"}

# Set the URL of the binary to download based on the architecture
if [[ $ARCH == "x86_64" ]]; then
	DOWNLOAD_URL="https://github.com/bazelbuild/buildtools/releases/download/v${VERSION}/buildifier-linux-amd64"
elif [[ $ARCH == "arm64" || $ARCH == "aarch64" ]]; then
	DOWNLOAD_URL="https://github.com/bazelbuild/buildtools/releases/download/v${VERSION}/buildifier-linux-arm64"
else
	echo "Unsupported architecture: $ARCH"
	exit 1
fi

# Download and install the binary
curl --silent --show-error --remove-on-error --retry 3 --location "$DOWNLOAD_URL" -o buildifier &&
	mv buildifier /usr/local/bin &&
	chmod +x /usr/local/bin/buildifier
