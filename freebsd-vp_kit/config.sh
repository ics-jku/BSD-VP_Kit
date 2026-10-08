MAKEFS_BIN=$(pwd)/tools/makefs/src/makefs
FREEBSD_OBJDIRPREFIX=$(pwd)/build/obj
FREEBSD_METALOG=$(pwd)/build/METALOG.world
FREEBSD_DESTDIR=$(pwd)/build/destdir
FREEBSD_DESTDIR_REDUCED=$(pwd)/build/destdir_reduced
FREEBSD_DESTDIR_PREPARED=$(pwd)/build/destdir_prepared
FREEBSD_ROOTFS_IMG=$(pwd)/build/rootfs.ufs2
FREEBSD_DESTDIR_KERNEL=$(pwd)/build/destdir_kernel
FINAL_KERNEL_IMG=$(pwd)/build/FreeBSD15_kernel_rootfs.elf

OPENSBI_DIR=$(pwd)/opensbi

HOME_DIR=${HOME_DIR:-$HOME}
CHERI_BIN_DIR=${FREEBSD_CHERI_SDK_BIN:-$HOME_DIR/cheri/output/sdk/bin}

# Plain FreeBSD and upstream OpenSBI revisions corresponding to this kit.
FREEBSD_SRC_REVISION=3b4bc5d70e1c2066fcb6e8535941258c88999fa2
OPENSBI_VERSION=17729d44daf879e015950b0e9636afceefea0a59
# Keep the DTB outside the embedded 512 MiB rootfs/kernel load range.
OPENSBI_FDT_ADDR=0xa2000000

RISC_V_VP_PATH=$HOME_DIR/riscv-vp-plusplus