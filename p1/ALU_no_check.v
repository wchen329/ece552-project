/* An ALU.
 * Unconditionally gives flag outputs, control happens externally. 
 *
 * The opcode specifications are as follows:
 *
 * 0 - Add, 1 - Sub, 2 - XOR, 3 - RED, 4 - SLL, 5 - SRA, 6 - ROR, 7 - PADDSB
 *
 * wchen329@wisc.edu
 */
module ALU_no_check(A, B, op, out, flags);

	output [15:0] out;
	output [2:0] flags;
	input [15:0] A, B;
	input [2:0] op; 

	wire [15:0] add_out, sub_out, xor_out, red_out, sll_out, sra_out, ror_out, paddsb_out;
	wire [2:0] add_flags; 
	wire out_Z, out_V, out_N;

	// ALU Sub Modules
	addsub_16bit_cla ADDSUB(add_out, out_V, A, B, op[0]);
	xor_16bit XOR(xor_out, A, B); 
	PADDSB_16bit_cla PADDSB(paddsb_out, A, B);

	assign out =
	op == 0 ? add_out :
	op == 1 ? add_out :
	op == 2 ? xor_out :
	op == 3 ? red_out :
	op == 4 ? sll_out :
	op == 5 ? sra_out :
	op == 6 ? ror_out :
	op == 7 ? paddsb_out : 0; 

	assign out_Z = out == 0 ? 1 : 0; 
	assign out_N = out[15];

	assign flags =
		{out_Z, out_V ,out_N}; 

endmodule

