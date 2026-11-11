#!/bin/bash

set -e

. ./config.sh

firmware="$OPENSBI_DIR/build/platform/generic/firmware/fw_jump.elf"
if [[ ! -r "$firmware" ]]; then
	echo "ERROR: Missing OpenSBI firmware: $firmware. Run scripts/05_opensbi.sh." >&2
	exit 1
fi
if [[ ! -r "$FINAL_KERNEL_IMG" ]]; then
	echo "ERROR: Missing kernel: $FINAL_KERNEL_IMG. Run scripts/build_full.sh." >&2
	exit 1
fi
if [[ ! -r "$RISC_V_VP_DTB" ]]; then
	echo "ERROR: Missing device tree: $RISC_V_VP_DTB. Set RISC_V_VP_DTB to a matching VP device tree." >&2
	exit 1
fi

exec "$RISC_V_VP_BIN" \
	--use-data-dmi \
	--tlm-global-quantum=1000000 \
	--dtb-file "$RISC_V_VP_DTB" \
	--kernel-file "$FINAL_KERNEL_IMG" \
	"$firmware" \
	"$@"
