#!/bin/bash

set -e

. ./config.sh

mkdir -p "$CHERIBSD_OBJDIRPREFIX"
cd cheribsd

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
)

make_args=(
	TARGET=$CHERIBSD_TARGET
	TARGET_ARCH=$CHERIBSD_TARGET_ARCH
	TARGET_CPUTYPE=$CHERIBSD_TARGET_CPUTYPE
	-DWITHOUT_WERROR
	-DDB_FROM_SRC
	-DI_REALLY_MEAN_NO_CLEAN
	-DNO_ROOT
	-DBUILD_WITH_STRICT_TMPPATH
	-DWITHOUT_CLEAN
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
	-DWITHOUT_GCC_BOOTSTRAP
	-DWITHOUT_CLANG_BOOTSTRAP
	-DWITHOUT_LLD_BOOTSTRAP
	-DWITHOUT_LIB32
	-DWITHOUT_LIB64
	-DWITH_ELFTOOLCHAIN_BOOTSTRAP
	-DWITH_TOOLCHAIN
	-DWITHOUT_BINUTILS_BOOTSTRAP
	-s
	-de
)

echo "+++ Build CheriBSD World (from toolchain to rootfs)"
env "${make_env[@]}" tools/build/make.py -j$(nproc) buildworld "${make_args[@]}"

echo "+++ Install CheriBSD World (destdir, rootfs)"
env "${make_env[@]}" DESTDIR=$CHERIBSD_DESTDIR METALOG=$CHERIBSD_METALOG \
	tools/build/make.py -j$(nproc) installworld "${make_args[@]}" -DNO_SAFE_LIBINSTALL

echo "+++ Install CheriBSD distribution files"
env "${make_env[@]}" DESTDIR=$CHERIBSD_DESTDIR METALOG=$CHERIBSD_METALOG \
	tools/build/make.py -j$(nproc) distribution "${make_args[@]}" -DNO_SAFE_LIBINSTALL

echo "+++ Copy critical /etc config files (fallback for cross-compile)"
mkdir -p "$CHERIBSD_DESTDIR/etc"

SRCDIR=$(pwd)
cp -v "$SRCDIR/libexec/rc/rc" "$CHERIBSD_DESTDIR/etc/rc" || { echo "ERROR: Failed to copy rc"; exit 1; }
cp -v "$SRCDIR/usr.bin/login/login.conf" "$CHERIBSD_DESTDIR/etc/login.conf" || { echo "ERROR: Failed to copy login.conf"; exit 1; }
cp -v "$SRCDIR/lib/libc/rpc/netconfig" "$CHERIBSD_DESTDIR/etc/netconfig" || { echo "ERROR: Failed to copy netconfig"; exit 1; }

echo "+++ Ensure rc framework is present"
mkdir -p "$CHERIBSD_DESTDIR/etc/rc.d"
if [[ -z "$(ls -A "$CHERIBSD_DESTDIR/etc/rc.d" 2>/dev/null)" ]] ; then
	echo "rc.d is empty, copying fallback rc framework from source"
	cp -a "$SRCDIR/libexec/rc/rc.d/." "$CHERIBSD_DESTDIR/etc/rc.d/" || { echo "ERROR: Failed to copy rc.d"; exit 1; }
	cp -v "$SRCDIR/libexec/rc/rc.subr" "$CHERIBSD_DESTDIR/etc/rc.subr" || { echo "ERROR: Failed to copy rc.subr"; exit 1; }
	cp -v "$SRCDIR/libexec/rc/network.subr" "$CHERIBSD_DESTDIR/etc/network.subr" || { echo "ERROR: Failed to copy network.subr"; exit 1; }
	cp -v "$SRCDIR/libexec/rc/netstart" "$CHERIBSD_DESTDIR/etc/netstart" || { echo "ERROR: Failed to copy netstart"; exit 1; }
fi

echo "done."
