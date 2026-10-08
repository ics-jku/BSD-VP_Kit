# BSD-VP_Kit
This repository contains build kits for BSD-based operating systems
targeting the RISC-V VP++ virtual prototype.

The kits provide build scripts, configurations, and documentation
to enable reproducible OS builds for research and experimentation.
These kits are primarily intended as research artifacts to facilitate the reproduction of experimental environments rather than as general-purpose build systems.

Refer to the README files in the respective subdirectories for
build instructions and further details.

## Contents
* cheribsd-vp-kit-isav9: CheriBSD targeting RV64 with CHERI-ISAv9
* freebsd-vp-kit: FreeBSD targeting RV64

## Publications
The following publications describe research conducted using one or more of these kits:
* Counterfactual Exploit Validation on CHERI-enabled RISC-V Using Virtual Prototypes, cite as:
```
@inproceedings{HSG:2026,
  author = {Andreas Hinterdorfer and Manfred Schl{\"{a}}gl and Daniel Gro{\ss}e},
  title = {Counterfactual Exploit Validation on {CHERI}-enabled {RISC-V} Using Virtual Prototypes},
  booktitle = {International Conference on Very Large Scale Integration of System-on-Chip (VLSI-SoC)},
  url = {https://ics.jku.at/files/2026VLSI-SoC_Counterfactual_Exploit_Validation_on_CHERI-Enabled_RISC-V_Using_Virtual-Prototypes.pdf},
  year = 2026
}
```