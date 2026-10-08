#!/bin/bash

set -e

 . config.sh

mkdir -p $FREEBSD_OBJDIRPREFIX
cd cheribsd

echo "+++ Build FreeBSD World (from toolchain to rootfs)"
MAKEOBJDIRPREFIX=$FREEBSD_OBJDIRPREFIX CC=/usr/bin/clang CXX=/usr/bin/clang++ CPP=/usr/bin/clang-cpp STRIPBIN=/usr/bin/strip  XCC=$CHERI_BIN_DIR/clang XCXX=$CHERI_BIN_DIR/clang++ XCPP=$CHERI_BIN_DIR/clang-cpp X_COMPILER_TYPE=clang XLD=$CHERI_BIN_DIR/ld.lld tools/build/make.py -j$(nproc)  buildworld TARGET=riscv TARGET_ARCH=riscv64  -DDB_FROM_SRC -DI_REALLY_MEAN_NO_CLEAN -DNO_ROOT -DBUILD_WITH_STRICT_TMPPATH XAR=$CHERI_BIN_DIR/llvm-ar XNM=$CHERI_BIN_DIR/llvm-nm XSIZE=$CHERI_BIN_DIR/llvm-size XSTRIPBIN=$CHERI_BIN_DIR/llvm-strip XSTRINGS=$CHERI_BIN_DIR/llvm-strings XOBJCOPY=$CHERI_BIN_DIR/llvm-objcopy XRANLIB=$CHERI_BIN_DIR/llvm-ranlib XLLVM_LINK=$CHERI_BIN_DIR/llvm-link -DWITHOUT_CLEAN -DWITH_TESTS -DWITHOUT_INIT_ALL_ZERO -DWITHOUT_INIT_ALL_PATTERN -DWITHOUT_MAN -DWITHOUT_MAIL -DWITH_DISK_IMAGE_TOOLS_BOOTSTRAP -DWITHOUT_PROFILE -DWITHOUT_OFED -DWITH_MALLOC_PRODUCTION -DWITHOUT_GCC -DWITHOUT_CLANG -DWITHOUT_LLD -DWITHOUT_GCC_BOOTSTRAP -DWITHOUT_CLANG_BOOTSTRAP -DWITHOUT_LLD_BOOTSTRAP -DWITHOUT_LIB32 -DWITH_ELFTOOLCHAIN_BOOTSTRAP -DWITH_TOOLCHAIN -DWITHOUT_BINUTILS_BOOTSTRAP -s -de  # -DWITHOUT_LLDB

if [[ $? != 0 ]] ; then
	echo "-------------------------------- ERROR"
	exit 1
fi

echo "+++ Install FreeBSD World (destdir, rootfs)"
MAKEOBJDIRPREFIX=$FREEBSD_OBJDIRPREFIX DESTDIR=$FREEBSD_DESTDIR CC=/usr/bin/clang CXX=/usr/bin/clang++ CPP=/usr/bin/clang-cpp STRIPBIN=/usr/bin/strip XCC=$CHERI_BIN_DIR/clang XCXX=$CHERI_BIN_DIR/clang++ XCPP=$CHERI_BIN_DIR/clang-cpp X_COMPILER_TYPE=clang XLD=$CHERI_BIN_DIR/ld.lld METALOG=$FREEBSD_METALOG tools/build/make.py -j$(nproc) installworld TARGET=riscv TARGET_ARCH=riscv64 -DDB_FROM_SRC -DI_REALLY_MEAN_NO_CLEAN -DNO_ROOT -DBUILD_WITH_STRICT_TMPPATH XAR=$CHERI_BIN_DIR/llvm-ar XNM=$CHERI_BIN_DIR/llvm-nm XSIZE=$CHERI_BIN_DIR/llvm-size XSTRIPBIN=$CHERI_BIN_DIR/llvm-strip XSTRINGS=$CHERI_BIN_DIR/llvm-strings XOBJCOPY=$CHERI_BIN_DIR/llvm-objcopy XRANLIB=$CHERI_BIN_DIR/llvm-ranlib XLLVM_LINK=$CHERI_BIN_DIR/llvm-link -DNO_SAFE_LIBINSTALL -DWITHOUT_CLEAN -DWITH_TESTS -DWITHOUT_INIT_ALL_ZERO -DWITHOUT_INIT_ALL_PATTERN -DWITHOUT_MAN -DWITHOUT_MAIL -DWITH_DISK_IMAGE_TOOLS_BOOTSTRAP -DWITHOUT_PROFILE -DWITHOUT_OFED -DWITH_MALLOC_PRODUCTION -DWITHOUT_GCC -DWITHOUT_CLANG -DWITHOUT_LLD -DWITHOUT_GCC_BOOTSTRAP -DWITHOUT_CLANG_BOOTSTRAP -DWITHOUT_LLD_BOOTSTRAP -DWITHOUT_LIB32 -DWITH_ELFTOOLCHAIN_BOOTSTRAP -DWITH_TOOLCHAIN -DWITHOUT_BINUTILS_BOOTSTRAP -s -de # -DWITHOUT_LLDB

echo "+++ Install FreeBSD distribution files"
MAKEOBJDIRPREFIX=$FREEBSD_OBJDIRPREFIX DESTDIR=$FREEBSD_DESTDIR METALOG=$FREEBSD_METALOG CC=/usr/bin/clang CXX=/usr/bin/clang++ CPP=/usr/bin/clang-cpp STRIPBIN=/usr/bin/strip XCC=$CHERI_BIN_DIR/clang XCXX=$CHERI_BIN_DIR/clang++ XCPP=$CHERI_BIN_DIR/clang-cpp X_COMPILER_TYPE=clang XLD=$CHERI_BIN_DIR/ld.lld tools/build/make.py -j$(nproc) distribution TARGET=riscv TARGET_ARCH=riscv64 -DDB_FROM_SRC -DI_REALLY_MEAN_NO_CLEAN -DNO_ROOT -DBUILD_WITH_STRICT_TMPPATH XAR=$CHERI_BIN_DIR/llvm-ar XNM=$CHERI_BIN_DIR/llvm-nm XSIZE=$CHERI_BIN_DIR/llvm-size XSTRIPBIN=$CHERI_BIN_DIR/llvm-strip XSTRINGS=$CHERI_BIN_DIR/llvm-strings XOBJCOPY=$CHERI_BIN_DIR/llvm-objcopy XRANLIB=$CHERI_BIN_DIR/llvm-ranlib XLLVM_LINK=$CHERI_BIN_DIR/llvm-link -DNO_SAFE_LIBINSTALL -DWITHOUT_CLEAN -DWITH_TESTS -DWITHOUT_INIT_ALL_ZERO -DWITHOUT_INIT_ALL_PATTERN -DWITHOUT_MAN -DWITHOUT_MAIL -DWITH_DISK_IMAGE_TOOLS_BOOTSTRAP -DWITHOUT_PROFILE -DWITHOUT_OFED -DWITH_MALLOC_PRODUCTION -DWITHOUT_GCC -DWITHOUT_CLANG -DWITHOUT_LLD -DWITHOUT_GCC_BOOTSTRAP -DWITHOUT_CLANG_BOOTSTRAP -DWITHOUT_LLD_BOOTSTRAP -DWITHOUT_LIB32 -DWITH_ELFTOOLCHAIN_BOOTSTRAP -DWITH_TOOLCHAIN -DWITHOUT_BINUTILS_BOOTSTRAP -s -de

echo "+++ Copy critical /etc config files (fallback for cross-compile)"
mkdir -p $FREEBSD_DESTDIR/etc

SRCDIR=$(pwd)
cp -v "$SRCDIR/libexec/rc/rc" "$FREEBSD_DESTDIR/etc/rc" || { echo "ERROR: Failed to copy rc"; exit 1; }
cp -v "$SRCDIR/usr.bin/login/login.conf" "$FREEBSD_DESTDIR/etc/login.conf" || { echo "ERROR: Failed to copy login.conf"; exit 1; }
cp -v "$SRCDIR/lib/libc/rpc/netconfig" "$FREEBSD_DESTDIR/etc/netconfig" || { echo "ERROR: Failed to copy netconfig"; exit 1; }

echo "+++ Ensure rc framework is present"
mkdir -p "$FREEBSD_DESTDIR/etc/rc.d"
if [[ -z "$(ls -A "$FREEBSD_DESTDIR/etc/rc.d" 2>/dev/null)" ]] ; then
	echo "rc.d is empty, copying fallback rc framework from source"
	cp -a "$SRCDIR/libexec/rc/rc.d/." "$FREEBSD_DESTDIR/etc/rc.d/" || { echo "ERROR: Failed to copy rc.d"; exit 1; }
	cp -v "$SRCDIR/libexec/rc/rc.subr" "$FREEBSD_DESTDIR/etc/rc.subr" || { echo "ERROR: Failed to copy rc.subr"; exit 1; }
	cp -v "$SRCDIR/libexec/rc/network.subr" "$FREEBSD_DESTDIR/etc/network.subr" || { echo "ERROR: Failed to copy network.subr"; exit 1; }
	cp -v "$SRCDIR/libexec/rc/netstart" "$FREEBSD_DESTDIR/etc/netstart" || { echo "ERROR: Failed to copy netstart"; exit 1; }
fi

echo "done."
