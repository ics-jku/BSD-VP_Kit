#!/bin/bash


set -e
scripts/02_01_reduce_rootfs.sh
scripts/02_02_prepare_rootfs.sh
scripts/03_create_rootfs_image.sh
scripts/04_build_kernel.sh
