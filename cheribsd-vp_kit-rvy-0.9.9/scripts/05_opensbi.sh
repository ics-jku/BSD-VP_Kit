#!/bin/bash
set -e

. ./config.sh

echo "+++ Clone OpenSBI"

if ! [[ -d $OPENSBI_DIR ]] ; then
	git clone --no-checkout https://github.com/qwattash/cheri-alliance-opensbi.git "$OPENSBI_DIR"
fi

cd "$OPENSBI_DIR"
revision=0568a41375f8996976f4f864bb2c9f63b68c3a32
# This revision may no longer be reachable from the upstream branch tips.
if ! git cat-file -e "$revision^{commit}" 2>/dev/null; then
	git fetch origin "$revision"
fi

if [[ $(git rev-parse HEAD) != "$revision" ]]; then
	git checkout --detach "$revision"
fi

echo "+++ Apply OpenSBI patches"
for patch in "$ROOT_DIR"/OpenSBI_patches/*.patch; do
	if git apply --reverse --check "$patch" 2>/dev/null; then
		echo "Already applied: $patch"
	else
		git apply --check "$patch"
		git apply "$patch"
	fi
done

rv_flags="-target riscv64-unknown-elf -B$CHERI_BIN_DIR -march=$OPENSBI_RISCV_MARCH -mabi=$OPENSBI_RISCV_ABI -mno-relax -Xclang -target-feature -Xclang +cheri-bounded-vararg -Xclang -target-feature -Xclang +cheri-bounded-memarg-caller -Xclang -target-feature -Xclang +cheri-bounded-memarg-callee -mcmodel=medany -Qunused-arguments"
make -B LLVM=1 O=build I="${OPENSBI_INSTALL_DIR}" \
	CC="$CHERI_BIN_DIR/clang $rv_flags" \
	CXX="$CHERI_BIN_DIR/clang++ $rv_flags" \
	CPP="$CHERI_BIN_DIR/clang-cpp $rv_flags" \
	LD=$CHERI_BIN_DIR/ld.lld \
	AR=$CHERI_BIN_DIR/llvm-ar \
	OBJCOPY=$CHERI_BIN_DIR/llvm-objcopy \
	FW_PIC=n \
	FW_OPTIONS=0x2 \
	PLATFORM_RISCV_ABI=$OPENSBI_PLATFORM_RISCV_ABI \
	PLATFORM_RISCV_ISA=$OPENSBI_PLATFORM_RISCV_ISA \
	PLATFORM_RISCV_XLEN=64 \
	FW_TEXT_START=0x80000000 \
	FW_JUMP_ADDR=$OPENSBI_FW_JUMP_ADDR \
	FW_JUMP_FDT_ADDR=$OPENSBI_FW_FDT_ADDR \
	FW_PAYLOAD_PATH=$FINAL_KERNEL_IMG \
	FW_PAYLOAD_FDT_ADDR=$OPENSBI_FW_FDT_ADDR \
	PLATFORM=generic \
	-j$(nproc)

echo "done."
