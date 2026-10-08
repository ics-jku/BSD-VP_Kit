MAKEFS_BIN=$(pwd)/tools/makefs/src/makefs
CHERIBSD_OBJDIRPREFIX=$(pwd)/build/obj
CHERIBSD_METALOG=$(pwd)/build/METALOG.world
CHERIBSD_DESTDIR=$(pwd)/build/destdir
CHERIBSD_DESTDIR_REDUCED=$(pwd)/build/destdir_reduced
CHERIBSD_DESTDIR_PREPARED=$(pwd)/build/destdir_prepared
CHERIBSD_ROOTFS_IMG=$(pwd)/build/rootfs.ufs2
CHERIBSD_DESTDIR_KERNEL=$(pwd)/build/destdir_kernel
FINAL_KERNEL_IMG=$(pwd)/build/CheriBSD_kernel_rootfs.elf

OPENSBI_DIR=$(pwd)/opensbi

HOME_DIR=/home/ics
CHERI_BIN_DIR=$HOME_DIR/cheri/output/sdk/bin
RISC_V_VP_PATH=$HOME_DIR/riscv-vp-plusplus