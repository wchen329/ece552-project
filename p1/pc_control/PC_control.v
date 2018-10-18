/* PC Control
 *
 * wchen329@wisc.edu
 */
module PC_control(input [2:0] C, input [8:0] I, input [2:0] F, input [15:0] PC_in, output [15:0] PC_out);

	wire [15:0] taken_PC, not_taken_PC;
	wire branch_taken;
	wire Zf, Vf, Nf;

	adder_16bit_cla_simple ADD_NOTT(not_taken_PC, PC_in, {{14{1'b0}} , 2'b10});
	adder_16bit_cla_simple ADD_TAKE(taken_PC, not_taken_PC, { {6{I[8]}}, I[8:0], 1'b0});

	assign {Zf, Vf, Nf} = F[2:0];
	assign branch_taken =
		C == 0 ?
			Zf == 0 ? 1 : 0
			:	// Not Equal
		C == 1 ?
			Zf == 1 ? 1 : 0
			:	// Equal
		C == 2 ?
			Zf == 0 ? Nf == 0 ? 1 : 0 : 0
			:	// Greater Than
		C == 3 ?
			Nf == 1 ? 1 : 0
			:	// Less Than
		C == 4 ?
			Zf == 1 ? 1 : Zf == 0 ? Nf == 0 ? 1 : 0 : 0
			:	// Greater Than or Equal
		C == 5 ?
			Nf == 1 ? 1 : Zf == 1 ? 1 : 0
			:	// Less Than or Equal
		C == 6 ?
			Vf == 1 ? 1 : 0
			:	// Overflow
		C == 7 ? 1 : 0;	// Unconditional

	assign PC_out = branch_taken == 0 ? not_taken_PC : taken_PC;

endmodule
