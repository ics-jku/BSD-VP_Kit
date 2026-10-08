# FreeBSD VP Kit
This project is to document the used FreeBSD kernel for experiments with FreeBSD on RISC-V VP++.
The goal is to get a kernel image, closely aligned to the CheriBSD kernel used for similar experiments.
It is therefore built using the same CHERI-aware compiler, although this is not strictly necessary to build a regular FreeBSD image.
**This is not designed for production use**, its just a set of shell scripts, documenting how the used kernel image was created.
This image is tailored to run on RISC-V VP++.

## Requirements
* CHERI Clang / LLVM: clang version 17.0.0 (https://github.com/CTSRD-CHERI/llvm-project.git Commit: 9458196a7a269b431739f609a37a3794616eaa58)
    * Installed via cheribuild (https://github.com/CTSRD-CHERI/cheribuild Commit: 3d55497c6083eed75be51ddc324b0660a8321588)

* RISC-V VP++: (https://github.com/ics-jku/riscv-vp-plusplus Commit: f02a989eafdbd9a5f09a2c94433bf502784b24f5)

## Usage
* **Make sure to check all scripts before executing them!**
* Change paths in 'config.sh' to align with your system
* Execute 'scripts/build_full.sh' to build kernel image the first time
* Execute 'scripts/run_freebsd.sh' to boot image on RISC-V VP++