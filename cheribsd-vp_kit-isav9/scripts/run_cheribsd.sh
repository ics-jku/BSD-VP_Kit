 #!/bin/bash

set -e
 
 . config.sh

$RISC_V_VP_PATH/vp/build/bin/qemu_virt64-cheriv9-sc-vp \
--use-data-dmi \
--tlm-global-quantum=1000000 \
--dtb-file $RISC_V_VP_PATH/vp/build/bin/qemu_virt64-cheriv9-sc-vp.dtb \
--kernel-file ./build/CheriBSD_kernel_rootfs.elf \
./opensbi/build/platform/generic/firmware/fw_jump.elf
