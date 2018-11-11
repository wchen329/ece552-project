/* Hazard Detection Unit.
 * Detects Pipeline Hazards and raises flags to correct them.
 *
 * wchen329@wisc.edu
 */
module Hazard_Detect_Unit(	RegisterBl_1_ID_EX, RegisterBl_2_ID_EX, RegisterDst_ID_EX, MemRead_ID_EX, RegWrite_ID_EX,
				RegisterBl_1_EX_MEM, RegisterBl_2_EX_MEM, RegisterDst_EX_MEM, MemRead_EX_MEM, MemWrite_EX_MEM, RegWrite_EX_MEM,
				RegisterDst_MEM_WB, RegWrite_MEM_WB,
				no_op, hold, EX_EX_FW, MEM_EX_FW, EX_ID_FW, MEM_MEM_FW);
	// INPUTS
	input [3:0] RegisterBl_1_ID_EX, RegisterBl_2_ID_EX, RegisterBl_1_EX_MEM, RegisterBl_2_EX_MEM, RegisterDst_ID_EX, RegisterDst_EX_MEM, RegisterDst_MEM_WB; // Register number corresponding to port label
	input MemRead_ID_EX,
		RegWrite_ID_EX,
		MemRead_EX_MEM,
		MemWrite_EX_MEM,
		RegWrite_EX_MEM,
		RegWrite_MEM_WB;

	// OUTPUTS
	output [3:0] no_op; // no-op signal, each single bit of the no_op vector corresponds to a pipeline register in which to enter it.
			    // no_op[0] - corresponds to IF/ID
			    // no_op[1] - corresponds to ID/EX
			    // no_op[2] - corresponds to EX/MEM
			    // no_op[3] - corresponds to MEM/WB
	output [3:0] hold;  // hold signal, for when no ops are inserted in the middle of the pipeline, tell instructions upstream to "hold"
			    // hold[0] - corresponds to IF/ID AND the PC
			    // hold[1] - corresponds to ID/EX
			    // hold[2] - corresponds to EX/MEM
			    // hold[3] - corresponds to MEM/WB

	output [1:0] EX_EX_FW;   // true if EX-EX forwarding is going to occur, bit 0 is forwarding_flag for ALU arg (1), and bit 2 is forwarding flag for ALU arg (2)
	output [1:0] MEM_EX_FW;  // true if MEM-EX forwarding is going to occur, bit 0 is forwarding_flag for ALU arg (1), and bit 2 is forwarding flag for ALU arg (2)
	output [1:0] EX_ID_FW;   // true if EX-ID forwarding is going to occur, bit 0 is forwarding_flag for ALU arg (1), and bit 2 is forwarding flag for ALU arg (2)
	output MEM_MEM_FW;	 // true if MEM-MEM forwarding is going to occur, assumption that bit line 2 is used as the source register for a store.

	// Set EX_EX_FW to ALU input 1
		assign EX_EX_FW[0] = RegisterDst_EX_MEM == RegisterBl_1_ID_EX ?
			RegisterDst_EX_MEM != 0 ?
				RegWrite_EX_MEM == 1 ? 1
				: 0
			: 0
		: 0;

	// Set EX_EX_FW to ALU input 2
	assign EX_EX_FW[1] = RegisterDst_EX_MEM == RegisterBl_2_ID_EX ?
			RegisterDst_EX_MEM != 0 ?
				RegWrite_EX_MEM == 1 ? 1
				: 0
			: 0
		: 0;


	// Set MEM_EX_FW to ALU input 1
	assign MEM_EX_FW[0] = RegisterDst_MEM_WB == RegisterBl_1_ID_EX ?
			RegisterDst_MEM_WB != 0 ?
				RegWrite_MEM_WB == 1 ? 1
				: 0
			: 0
		: 0;	

	// Set MEM_EX_FW to ALU input 2
	assign MEM_EX_FW[1] = RegisterDst_MEM_WB == RegisterBl_2_ID_EX ?
			RegisterDst_MEM_WB != 0 ?
				RegWrite_MEM_WB == 1 ? 1
				: 0
			: 0
		: 0;	

	// Set MEM_MEM_FW to STORE input
	assign MEM_MEM_FW = RegisterDst_MEM_WB == RegisterBl_2_EX_MEM ?
			RegisterDst_MEM_WB != 0 ?
				RegWrite_MEM_WB == 1?
					MemWrite_EX_MEM == 1 ? 1
					:0
				: 0
			: 0
		: 0;

endmodule