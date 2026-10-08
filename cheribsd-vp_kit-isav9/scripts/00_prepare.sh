#!/bin/bash

set -e

 . config.sh

echo "+++ Get and build makefs to create CheriBSD ufs/ffs boot images"
if ! [[ -d tools/makefs ]] ; then
	mkdir -p tools
	cd tools
	git clone https://github.com/kusumi/makefs
	cd makefs
	git checkout ccdddf6aaaadd2497fd3dc5d4c31dc84cfc68418
	make USE_HAMMER2=0
	cd ../..
else
	echo "ALREADY BUILT?"
fi

echo "+++ Get CheriBSD sources"
if ! [[ -d cheribsd ]] ; then
	git clone https://github.com/CTSRD-CHERI/cheribsd.git
	( cd cheribsd && git checkout 0baabd958251aee09f914a5e5c0a81bef3ddf7eb )
else
	echo "ALREADY BUILT?"
fi

echo "+++ Apply patches for CheriBSD World (from toolchain to rootfs)"
cd cheribsd
for patch in ../CheriBSD_patches/*; do
	# The kernel stage regenerates this file from configs/GENERIC_WITH_ROOTFS.in.
	# Its machine-specific contents must not invalidate the applied-patch check.
	if git apply --reverse --check \
	    --exclude=sys/riscv/conf/GENERIC_WITH_ROOTFS "$patch" 2>/dev/null; then
		echo "Already applied: $patch"
	else
		git apply --check "$patch"
		git apply "$patch"
	fi
done

echo "done."
