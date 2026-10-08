#!/bin/bash

set -e

 . config.sh

echo "+++ Get and build makefs to create FreeBSD ufs/ffs boot images"
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

echo "+++ Get FreeBSD sources"
if ! [[ -d cheribsd ]] ; then
	git clone https://github.com/CTSRD-CHERI/cheribsd.git
	( cd cheribsd && git checkout $FREEBSD_SRC_REVISION )
else
	echo "ALREADY BUILT?"
fi

# Reject old checkouts with committed patches instead of silently reusing them.
if [[ $(git -C cheribsd rev-parse HEAD) != "$FREEBSD_SRC_REVISION" ]]; then
	echo "ERROR: source revision mismatch; see README.md for migration."
	exit 1
fi

echo "+++ Apply patches for FreeBSD World (from toolchain to rootfs)"
cd cheribsd
for patch in ../FreeBSD_patches/*; do
	if git apply --reverse --check "$patch" 2>/dev/null; then
		echo "Already applied: $patch"
	else
		git apply --check "$patch"
		git apply "$patch"
	fi
done

echo "done."
