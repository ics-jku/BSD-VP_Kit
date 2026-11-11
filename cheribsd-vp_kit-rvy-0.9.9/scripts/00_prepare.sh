#!/bin/bash

set -e

. ./config.sh

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
	git clone --no-checkout https://github.com/CTSRD-CHERI/cheribsd.git
fi

cd cheribsd
revision=d0fecec30d23df59df426c7790dee1b3a06a1f96
# This revision may no longer be reachable from the upstream branch tips.
if ! git cat-file -e "$revision^{commit}" 2>/dev/null; then
	git fetch origin "$revision"
fi

if [[ $(git rev-parse HEAD) != "$revision" ]]; then
	git checkout --detach "$revision"
fi

echo "+++ Apply patches for CheriBSD World (from toolchain to rootfs)"
for patch in "$ROOT_DIR"/CheriBSD_patches/*.patch; do
	if git apply --reverse --check "$patch" 2>/dev/null; then
		echo "Already applied: $patch"
	else
		git apply --check "$patch"
		git apply "$patch"
	fi
done

echo "done."
