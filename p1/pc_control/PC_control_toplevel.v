/* The PC Control top-level.
 * Takes in select signal called Branch_Inst and the current PC value and required inputs for PC Control.
 * If a Branch then BranchInst is true. Otherwise false.
 * Also takes in Register_In, active high. 1 implies BR, 0 implies B
 * Rs_In is to be connected to the Rs output of the Register file.
 *
 *
 * wchen329@wisc.edu
 */
module PC_control_toplevel(Branch_Inst, Register_In, Rs_In, C, Imm, Flags, current_PC, next_PC);

	input [15:0] current_PC, Rs_In;
	input [8:0] Imm;
	input [2:0] C, Flags;
	input Branch_Inst, Register_In;

	output [15:0] next_PC;

	wire [15:0] no_branch, branch, branch_imm, branch_reg;

	CLAdder16 NO_BRANCH(.Sum(no_branch), .A(current_PC), .B(16'h2));
	PC_control BRANCH(C, Imm, F, current_PC, branch_imm);

	// remove unaligned part of register if present
	assign branch_reg = Rs_In & -2;

	assign branch = Register_In == 0 ? branch_imm : branch_reg;
	assign next_PC = Branch_Inst == 0 ? no_branch : branch;

endmodule
