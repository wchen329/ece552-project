/* Hazard Detection Unit.
 * Detects Pipeline Hazards and raises flags to correct them.
 * Both MEM-EX and EX-EX forwarding flags can be hot at the same time if two successive operations write to the same register. That's okay.
 * To handle such a case, take the EX-EX path first since that would be the most recent and hence the valid value.
 *
 * wchen329@wisc.edu
 */
module Hazard_Detect_Unit(	BranchRegister_IF_ID, Branch_IF_ID, 
				RegisterBl_1_ID_EX, RegisterBl_2_ID_EX, RegisterDst_ID_EX, MemRead_ID_EX, RegWrite_ID_EX,
				RegisterBl_1_EX_MEM, RegisterBl_2_EX_MEM, RegisterDst_EX_MEM, MemRead_EX_MEM, MemWrite_EX_MEM, RegWrite_EX_MEM,
				RegisterDst_MEM_WB, RegWrite_MEM_WB,
				no_op, hold, EX_EX_FW, MEM_EX_FW, MEM_MEM_FW, EX_ID_BR_FW);
	// INPUTS
	input [3:0] RegisterBl_1_ID_EX, RegisterBl_2_ID_EX, RegisterBl_1_EX_MEM, RegisterBl_2_EX_MEM, RegisterDst_ID_EX, RegisterDst_EX_MEM, RegisterDst_MEM_WB, BranchRegister_IF_ID; // Register number corresponding to port label
	input 
		Branch_IF_ID;
		MemRead_ID_EX,
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
	output [3:0] hold;  // hold signal, for when no ops are inserted in the middle of the pipeline, tell instructions downstream to "hold"
			    // hold[0] - corresponds to IF/ID AND the PC
			    // hold[1] - corresponds to ID/EX
			    // hold[2] - corresponds to EX/MEM
			    // hold[3] - corresponds to MEM/WB

	output [1:0] EX_EX_FW;   // true if EX-EX forwarding is going to occur, bit 0 is forwarding_flag for ALU arg (1), and bit 2 is forwarding flag for ALU arg (2)
	output [1:0] MEM_EX_FW;  // true if MEM-EX forwarding is going to occur, bit 0 is forwarding_flag for ALU arg (1), and bit 2 is forwarding flag for ALU arg (2)
	output MEM_MEM_FW;	 // true if MEM-MEM forwarding is going to occur, assumption that bit line 2 is used as the source register for a store.
	output EX_ID_BR_FW;	 // true if EX-ID forwarding to the Branch Register is going to occur

	wire [1:0] ALU_LOAD_TO_USE;	// load to use for an arithmetic operation, insert stall at EX/MEM, stall everything upstream
	wire BRANCH_ARITH_OR_LOAD_TO_USE;	// load to use or arithmetic to use to a branch operation, insert a stall at ID/EX, stall everything upstream
	
	// Set EX_EX_FW to ALU input 1
	assign EX_EX_FW[0] = RegisterDst_EX_MEM == RegisterBl_1_ID_EX ?
			RegisterDst_EX_MEM != 0 ?
				RegWrite_EX_MEM == 1 ?
					MemRead_EX_MEM == 0 ? 1
					: 0
				: 0
			: 0
		: 0;

	// Set EX_EX_FW to ALU input 2
	assign EX_EX_FW[1] = RegisterDst_EX_MEM == RegisterBl_2_ID_EX ?
			RegisterDst_EX_MEM != 0 ?
				RegWrite_EX_MEM == 1 ?
					MemRead_EX_MEM == 0 ? 1
					: 0
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

	// Set BRANCH REGISTER to previous stage EX output, the corresponding stall is handled by BRANCH_ARITH_OR_LOAD_TO_USE signal
	assign EX_ID_BR_FW = BranchRegister_IF_ID == RegisterDst_EX_MEM ? 
				Branch_IF_ID == 1 ?
					RegisterDst_EX_MEM != 0 ? 1 : 0
				: 0
			: 0

	// Load to use Hazard Detection for LOAD to USE, insert STALL.
	assign BRANCH_REG_LOAD_TO_USE = BranchRegister_IF_ID == RegisterDst_EX_MEM ?
			Branch_IF_ID == 1 ?
				RegisterDst_EX_MEM != 0 ? 1 : 0
			: 0
		: 0;

	//  Load to Use Hazard Detection for ALU, insert STALL.
	assign ALU_LOAD_TO_USE[0] = RegisterDst_EX_MEM == RegisterBl_1_ID_EX ?
			RegisterDst_EX_MEM != 0 ?
				RegWrite_EX_MEM == 1 ?
					MemRead_EX_MEM == 1 ? 1
					: 0
				: 0
			: 0
		: 0;

	assign ALU_LOAD_TO_USE[1] = RegisterDst_EX_MEM == RegisterBl_2_ID_EX ?
			RegisterDst_EX_MEM != 0 ?
				RegWrite_EX_MEM == 1 ?
					MemRead_EX_MEM == 1 ? 1
					: 0
				: 0
			: 0
		: 0;

	// General Branch Hazard, insert STALL - assume that all preceding instructions modify the flag register, mentioned in lecture, but in future could be more efficient by checking opcode
	assign BRANCH_ARITH_OR_LOAD_TO_USE = Branch_IF_ID == 1 ? 1 : 0;

	// STALL - An ALU load to use also stalls a pipeline sufficiently for control hazards
	assign no_op =
		( |ALU_LOAD_TO_USE == 1) ? 4'b0010 : // ALU load to use- insert no-op at MEM stage.
		( BRANCH_REG_LOAD_TO_USE == 1 ) 4'b0010:
		( BRANCH_ARITH_OR_LOAD_TO_USE == 1) ? 4'b0100 : 0;
	assign hold =
		( |ALU_LOAD_TO_USE == 1) ? 4'b1100 :
		( BRANCH_REG_LOAD_TO_USE == 1 ) 4'b1100:
		( BRANCH_ARITH_OR_LOAD_TO_USE == 1) ? 4'b1000 : 0;

endmodule