#!/usr/bin/env bash
set -e

if [ "$(id -u)" -ne 0 ]; then
	echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
	exit 1
fi

apt_get_update() {
	if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
		echo "Running apt-get update..."
		apt-get update -y
	fi
}

check_packages() {
	if ! dpkg -s "$@" >/dev/null 2>&1; then
		apt_get_update
		apt-get -y install --no-install-recommends "$@"
	fi
}

export DEBIAN_FRONTEND=noninteractive

check_packages wget ca-certificates

# Install libtinfo5 for legacy CUDA tools (nsight-systems 2022.4.2) on Ubuntu 24.04 (Noble)
echo "Installing libtinfo5 for CUDA compatibility..."
TINFO5_URL="https://security.ubuntu.com/ubuntu/pool/universe/n/ncurses/libtinfo5_6.3-2ubuntu0.1_amd64.deb"
wget -qO /tmp/libtinfo5.deb "${TINFO5_URL}"
dpkg -i /tmp/libtinfo5.deb || apt-get install -f -y
rm /tmp/libtinfo5.deb

echo "Done!"
