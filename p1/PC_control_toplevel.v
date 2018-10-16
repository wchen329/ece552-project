/* The PC Control top-level.
 * Takes in one select signal called Branch_Inst and the current PC value and required inputs for PC Control.
 * If a Branch then BranchInst is true. Otherwise false. 
 *
 * wchen329@wisc.edu
 */
module PC_control_toplevel(Branch_Inst, C, Imm, Flags, current_PC, next_PC);

	input [15:0] current_PC;
	input [8:0] Imm;
	input [2:0] C, Flags;
	input Branch_Inst;

	output [15:0] next_PC;

	wire [15:0] no_branch, branch;
	
	adder_16bit_cla_simple NO_BRANCH(no_branch, current_PC, 2);
	PC_control BRANCH(C, Imm, F, current_PC, branch);	

	assign next_PC = Branch_Inst == 0 ? no_branch : branch;

endmodule
