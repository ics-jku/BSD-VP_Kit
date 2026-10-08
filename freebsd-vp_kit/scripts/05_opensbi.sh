#!/bin/bash

set -e

 . config.sh

echo "+++ Clone OpenSBI"

if ! [[ -d $OPENSBI_DIR ]] ; then
    git clone https://github.com/riscv-software-src/opensbi.git
	(cd opensbi && git checkout $OPENSBI_VERSION)
else
    echo "Already cloned"
fi

if [[ $(git -C "$OPENSBI_DIR" rev-parse HEAD) != "$OPENSBI_VERSION" ]]; then
	echo "ERROR: OpenSBI revision mismatch."
	exit 1
fi

cd $OPENSBI_DIR
nice gmake "CC=$CHERI_BIN_DIR/clang -target riscv64-unknown-elf -B$CHERI_BIN_DIR/ -march=rv64imac -mabi=lp64 -mcmodel=medany -Qunused-arguments" "CXX=$CHERI_BIN_DIR/clang++ -target riscv64-unknown-elf -B$CHERI_BIN_DIR/ -march=rv64imac -mabi=lp64 -mcmodel=medany -Qunused-arguments" "CPP=$CHERI_BIN_DIR/clang-cpp -target riscv64-unknown-elf -B$CHERI_BIN_DIR/ -march=rv64imac -mabi=lp64 -mcmodel=medany -Qunused-arguments" LD=$CHERI_BIN_DIR/ld.lld AR=$CHERI_BIN_DIR/llvm-ar OBJCOPY=$CHERI_BIN_DIR/llvm-objcopy FW_PIC=n FW_OPTIONS=0x2 PLATFORM_RISCV_ABI=lp64 PLATFORM_RISCV_ISA=rv64imac PLATFORM_RISCV_XLEN=64 PLATFORM=generic  FW_PAYLOAD_PATH=$FINAL_KERNEL_IMG FW_TEXT_START=0x80000000 FW_JUMP_FDT_ADDR=$OPENSBI_FDT_ADDR FW_PAYLOAD_FDT_ADDR=$OPENSBI_FDT_ADDR

echo "done."
