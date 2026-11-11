# CheriBSD-VP_Kit — RVY 0.9.9
This project documents the CheriBSD kernel used for experiments on RVY 0.9.9.
**This is not designed for production use**, but is a set of shell scripts documenting how the kernel image is created.
This image is tailored to run on RISC-V VP++.

## Requirements
* RVY 0.9.9 Clang / LLVM: clang version 20.0.0git (https://github.com/jrtc27/cheri-alliance-llvm-project.git Commit: 523fb52c0092acf690e94419f43a9bb084200bb7)
* RISC-V VP++ with RVY 0.9.9 support (https://github.com/ics-jku/riscv-vp-plusplus), built with `RVY099=OFF` for this pinned toolchain, providing `qemu_virt64y-sc-vp` and a matching single-core, 2 GiB device tree. Commit: 50c62f3b259b6cd2923a09f19c7e3ed9be436b89
    * `RVY099=OFF` is a workaround, that implements newer RVY0.9.10 semantics for reserved BEQ encodings that are used by this CheriBSD version. This will be resolved in future RVY versions.
* Linux host with the CheriBSD cross-build dependencies and `fakeroot`.

## Usage
* **Make sure to check all scripts before executing them!**
* Run commands from this kit directory.
* Change paths in `config.sh` to align with your system, including the toolchain, VP binary, and device tree.
* Execute `scripts/build_full.sh` to build the kernel image and OpenSBI the first time.
* After updating kernel patches, run `scripts/00_prepare.sh` and `scripts/04_build_kernel.sh` to apply them and rebuild the kernel.
* Execute `scripts/run_cheribsd.sh` to boot the image on RISC-V VP++.
