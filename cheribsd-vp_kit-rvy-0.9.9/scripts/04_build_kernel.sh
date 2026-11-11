#!/bin/bash

set -e

. ./config.sh

make_env=(
	MAKEOBJDIRPREFIX=$CHERIBSD_OBJDIRPREFIX
	CC=$HOST_CC
	CXX=$HOST_CXX
	CPP=$HOST_CPP
	STRIPBIN=$HOST_STRIPBIN
	XCC=$CHERI_BIN_DIR/clang
	XCXX=$CHERI_BIN_DIR/clang++
	XCPP=$CHERI_BIN_DIR/clang-cpp
	X_COMPILER_TYPE=clang
	XLD=$CHERI_BIN_DIR/ld.lld
	XAR=$CHERI_BIN_DIR/llvm-ar
	XNM=$CHERI_BIN_DIR/llvm-nm
	XSIZE=$CHERI_BIN_DIR/llvm-size
	XSTRIPBIN=$CHERI_BIN_DIR/llvm-strip
	XSTRINGS=$CHERI_BIN_DIR/llvm-strings
	XOBJCOPY=$CHERI_BIN_DIR/llvm-objcopy
	XRANLIB=$CHERI_BIN_DIR/llvm-ranlib
	XLLVM_LINK=$CHERI_BIN_DIR/llvm-link
	LD=$CHERI_BIN_DIR/ld.lld
	AR=$CHERI_BIN_DIR/llvm-ar
	NM=$CHERI_BIN_DIR/llvm-nm
	OBJCOPY=$CHERI_BIN_DIR/llvm-objcopy
	RANLIB=$CHERI_BIN_DIR/llvm-ranlib
	SIZE=$CHERI_BIN_DIR/llvm-size
	STRINGS=$CHERI_BIN_DIR/llvm-strings
)

make_args=(
	TARGET=$CHERIBSD_TARGET
	TARGET_ARCH=$CHERIBSD_TARGET_ARCH
	TARGET_CPUTYPE=$CHERIBSD_TARGET_CPUTYPE
	KERNCONF=GENERIC_WITH_ROOTFS
	DEBUG=-g
	-DDB_FROM_SRC
	-DNO_ROOT
	-DBUILD_WITH_STRICT_TMPPATH
	-DWITH_TESTS
	-DWITH_CHERI
	-DWITHOUT_INIT_ALL_ZERO
	-DWITHOUT_INIT_ALL_PATTERN
	-DWITHOUT_MAN
	-DWITHOUT_MAIL
	-DWITH_DISK_IMAGE_TOOLS_BOOTSTRAP
	-DWITHOUT_PROFILE
	-DWITHOUT_OFED
	-DWITH_MALLOC_PRODUCTION
	-DWITHOUT_GCC
	-DWITHOUT_CLANG
	-DWITHOUT_LLD
	-DWITHOUT_LLDB
	-DWITHOUT_GCC_BOOTSTRAP
	-DWITHOUT_CLANG_BOOTSTRAP
	-DWITHOUT_LLD_BOOTSTRAP
	-DWITHOUT_LIB32
	-DWITH_ELFTOOLCHAIN_BOOTSTRAP
	-DWITH_TOOLCHAIN
	-DWITHOUT_BINUTILS_BOOTSTRAP
	-s
	-de
)

echo "+++ Add kernel config"
sed "s#@CHERIBSD_ROOTFS_IMG@#$CHERIBSD_ROOTFS_IMG#g" \
	configs/GENERIC_WITH_ROOTFS.in > cheribsd/sys/riscv/conf/GENERIC_WITH_ROOTFS

echo "+++ Build CheriBSD Kernel with rootfs"
pushd cheribsd 2>&1 >/dev/null

# force rebuild
touch sys/kern/init_main.c

env "${make_env[@]}" tools/build/make.py --clean -j$(nproc) cleankernel "${make_args[@]}"
env "${make_env[@]}" tools/build/make.py --clean -j$(nproc) buildkernel "${make_args[@]}"

popd 2>&1 >/dev/null

echo "+++ Install CheriBSD Kernel with rootfs"
pushd cheribsd 2>&1 >/dev/null
env "${make_env[@]}" DESTDIR=$CHERIBSD_DESTDIR_KERNEL \
	tools/build/make.py -j$(nproc) installkernel "${make_args[@]}" \
	NO_INSTALLEXTRAKERNELS=no -DINSTALL_KERNEL_DOT_FULL -DWITH_KERNEL_SYMBOLS

popd 2>&1 >/dev/null

echo "+++ Extract and rename kernel+rootfs image"
rm -f "$FINAL_KERNEL_IMG"
cp "$CHERIBSD_DESTDIR_KERNEL/boot/kernel/kernel.full" "$FINAL_KERNEL_IMG"
ls -lh "$FINAL_KERNEL_IMG"

echo "done."
