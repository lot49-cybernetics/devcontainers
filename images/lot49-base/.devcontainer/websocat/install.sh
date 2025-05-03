#!/bin/bash

set -e

# Determine the architecture of the Linux system
ARCH=$(uname -m)

# Sets the exact version to install, with a default and override
VERSION=${VERSION:-"v1.13.0"}

# Set the URL of the binary to download based on the architecture
if [[ $ARCH == "x86_64" ]]; then
	DOWNLOAD_URL="https://github.com/vi/websocat/releases/download/${VERSION}/websocat.x86_64-unknown-linux-musl"
elif [[ $ARCH == "arm64" || $ARCH == "aarch64" ]]; then
	DOWNLOAD_URL="https://github.com/vi/websocat/releases/download/${VERSION}/websocat.aarch64-unknown-linux-musl"
else
	echo "Unsupported architecture: $ARCH"
	exit 1
fi

# Download and install the binary
curl --silent --show-error --remove-on-error --retry 3 --location "$DOWNLOAD_URL" -o websocat &&
	chmod a+x websocat &&
	mv websocat /usr/local/bin
