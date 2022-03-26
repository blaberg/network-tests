#!/bin/bash

# Output arguments to stderr.
function err() {
	echo "$@" >&2
}

# Output arguments to stderr and halt with non-zero exit code.
function fatal() {
	err "$@"
	exit 1
}

# Output usage and halt.
function usage() {
	fatal "usage: $0 <device type> <version>"
}

if [ "$#" -ne 2 ]; then
	usage
fi

device="$1"
version="$2"

set -o errexit

WORKDIR="/usr/src"
mkdir -p $WORKDIR
cd $WORKDIR

# Retrieve balena kernel module header for specific device and version (production)
url_ver="${version//+/%2B}"
wget --no-verbose "https://files.balena-cloud.com/images/${device}/${url_ver}/kernel_modules_headers.tar.gz"
tar xfz kernel_modules_headers.tar.gz
rm kernel_modules_headers.tar.gz

# Find kernel version. Supports only kernel version 4 and above
pushd "$WORKDIR/kernel_modules_headers" >/dev/null
kernelversion="$(make kernelversion)"
pattern="^(.)\.(.*)"
[[ $kernelversion =~ $pattern ]] || fatal "Invalid kernel version '$kernelversion'?!"
kernelmajor="${BASH_REMATCH[1]}"
popd >/dev/null

# Retrieve kernel source
wget --no-verbose "https://mirrors.edge.kernel.org/pub/linux/kernel/v${kernelmajor}.x/linux-${kernelversion}.tar.gz"
tar xfz "linux-${kernelversion}.tar.gz"
rm "linux-${kernelversion}.tar.gz"

# Build kernel modules
pushd "$WORKDIR/linux-${kernelversion}" >/dev/null
cp "${WORKDIR}/kernel_modules_headers/.config" "${WORKDIR}/kernel_modules_headers/Module.symvers" .
sed -i 's/# CONFIG_MACSEC is not set/CONFIG_MACSEC=m/g' .config
make modules_prepare
make M=drivers/net
make M=drivers/net modules
popd >/dev/null

# Copy kernel modules to output directory
OUTDIR="/modules/${device}/${version}"
mkdir -p "$OUTDIR"
pushd "$OUTDIR" >/dev/null
# can-dev module is a required dependency for CAN modules
cp "$WORKDIR/linux-${kernelversion}/drivers/net/macsec.ko" .
popd >/dev/null

# Cleanup
rm -rf "$WORKDIR/kernel_modules_headers"
rm -rf "$WORKDIR/linux-${kernelversion}"
