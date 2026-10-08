#!/bin/bash

set -e

 . config.sh

echo "+++ Clone OpenSBI"

if ! [[ -d $OPENSBI_DIR ]] ; then
    git clone https://github.com/CTSRD-CHERI/opensbi.git
	(cd opensbi && git checkout 140562164305690039c75f3895767e8a3411fa3f)
else
    echo "Already cloned"
fi

cd $OPENSBI_DIR
nice gmake "CC=$CHERI_BIN_DIR/clang -target riscv64-unknown-elf -B$CHERI_BIN_DIR/ -march=rv64imacxcheri -mabi=lp64 -mcmodel=medany -Qunused-arguments" "CXX=$CHERI_BIN_DIR/clang++ -target riscv64-unknown-elf -B$CHERI_BIN_DIR/ -march=rv64imacxcheri -mabi=lp64 -mcmodel=medany -Qunused-arguments" "CPP=$CHERI_BIN_DIR/clang-cpp -target riscv64-unknown-elf -B$CHERI_BIN_DIR/ -march=rv64imacxcheri -mabi=lp64 -mcmodel=medany -Qunused-arguments" LD=$CHERI_BIN_DIR/ld.lld AR=$CHERI_BIN_DIR/llvm-ar OBJCOPY=$CHERI_BIN_DIR/llvm-objcopy FW_PIC=n FW_OPTIONS=0x2 PLATFORM_RISCV_ABI=lp64 PLATFORM_RISCV_ISA=rv64imacxcheri PLATFORM_RISCV_XLEN=64 PLATFORM=generic  FW_PAYLOAD_PATH=$FINAL_KERNEL_IMG FW_TEXT_START=0x80000000

echo "done."
