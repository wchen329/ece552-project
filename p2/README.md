# ECE 552 Phase 2
CPU for WISC-F18 ISA, with five stage pipeline.

## Folders & Files
- `primitives` gadgets such as ADDer, XORer, MUXs etc. Purely combinational.
- `alu` all ALU related stuff. Purely combinational.
- `memory` provided memory module. Instruction and data memory.
- `registers` RegisterFile, FlagRegister and PipelineRegister.
- `control` all control units: ControlUnit, PCControl, DataHazard, ControlHazard etc. Purely combinational.
- `testbenches` all testbenches for modules.
- `manual-dbg` testbenches which all for manual debugging of certain modules
- `cpu.v` top-level data path. Wires everything together.
