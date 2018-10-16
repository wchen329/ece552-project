/* An ALU.
 * Unconditionally gives flag outputs, control happens externally. 
 *
 * The opcode specifications are as follows:
 *
 * 0 - Add, 1 - Sub, 2 - XOR, 3 - RED, 4 - SLL, 5 - SRA, 6 - ROR, 7 - PADDSB
 *
 * wchen329@wisc.edu
 */
module ALU_no_check(ALU_In1, ALU_In2, ALU_Op, ALU_Out, Flags_Out);

	output [15:0] ALU_Out;
	output [2:0] Flags_Out;
	input [15:0] ALU_In1, ALU_In2;
	input [2:0] ALU_Op; 

	wire [15:0] add_out, sub_out, xor_out, red_out, sll_out, sra_out, ror_out, paddsb_out;
	wire [2:0] add_flags; 
	wire ALU_Out_Z, ALU_Out_V, ALU_Out_N;

	// ALU Sub Modules
	addsub_16bit_cla ADDSUB(add_out, ALU_Out_V, ALU_In1, ALU_In2, ALU_Op[0]);
	xor_16bit XOR(xor_out, ALU_In1, ALU_In2); 
	PADDSB_16bit_cla PADDSB(paddsb_out, ALU_In1, ALU_In2);

	assign ALU_Out =
	ALU_Op == 0 ? add_out :
	ALU_Op == 1 ? add_out :
	ALU_Op == 2 ? xor_out :
	ALU_Op == 3 ? red_out :
	ALU_Op == 4 ? sll_out :
	ALU_Op == 5 ? sra_out :
	ALU_Op == 6 ? ror_out :
	ALU_Op == 7 ? paddsb_out : 0; 

	assign ALU_Out_Z = ALU_Out == 0 ? 1 : 0; 
	assign ALU_Out_N = ALU_Out[15];

	assign Flags_Out =
		{ALU_Out_Z, ALU_Out_V ,ALU_Out_N}; 

endmodule

