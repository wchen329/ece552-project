/* A simple 16 bit XOR
 *
 * wchen329@wisc.edu
 */
module xor_16bit(Output, In_One, In_Two);
	input [15:0] In_One, In_Two;
	output [15:0] Output;

	assign Output = In_One ^ In_Two;

endmodule

/* An ALU.
 * Unconditionally gives flag outputs, control happens externally.
 *
 * The opcode specifications are as follows:
 *
 * 0 - Add, 1 - Sub, 2 - XOR, 3 - RED, 4 - SLL, 5 - SRA, 6 - ROR, 7 - PADDSB
 *
 * In the event of a shift, the lower 4 bits of B become the shift ammount.
 *
 * wchen329@wisc.edu
 */
module ALU_no_check(A, B, op, out, flags);

	output [15:0] out;
	output [2:0] flags;
	input [15:0] A, B;
	input [2:0] op;

	wire [15:0] add_out, sub_out, xor_out, red_out, shift_out, paddsb_out;
	wire [2:0] add_flags;
	wire out_Z, out_V, out_N;

	// ALU Sub Modules
	addsub_16bit_cla ADDSUB(.Sum(add_out), .Ovfl(out_V), .A(A), .B(B), .Sub(op[0]));
	xor_16bit XOR(.Output(xor_out), .In_One(A), .In_Two(B));
	PADDSB_16bit_cla PADDSB(.Sum(paddsb_out), .A(A), .B(B));
	Shifter SSLSRAROR(.Shift_Out(shift_out), .Shift_In(A), .Shift_Val(B[3:0]), .Opcode(op));
	RED REDUCTION(.A(A), .B(B), .Reduction(red_out));

	assign out =
	op == 0 ? add_out :
	op == 1 ? add_out :
	op == 2 ? xor_out :
	op == 3 ? red_out :
	op == 4 ? shift_out :
	op == 5 ? shift_out :
	op == 6 ? shift_out :
	op == 7 ? paddsb_out : 0;

	assign out_Z = out == 0 ? 1 : 0;
	assign out_N = out[15];

	assign flags =
		{out_Z, out_V ,out_N};

endmodule

// monolithic ALU toplevel by Zhenghao Gu
module ALU(A, B, op, out, flagZVN);
	input [15:0] A, B;
	input [3:0]  op; // inst[15:12]
	output[15:0] out;
	output[2:0]  flagZVN;

	wire[15:0] arithmetic_result, bl_result, addr_result;
	ALU_no_check arithmetic_alu(.A(A), .B(B), .op(op[2:0]), .out(arithmetic_result), .flags(flagZVN));
	ByteLoader bl(.in(A), .u(B[7:0]), .high(op[0]), .out(bl_result));
	MemAddrUnit ma(.baseAddr(A), .offset(B[3:0]), .memAddr(addr_result));

	assign out = op[3:1]==3'b101 ? bl_result   :
	             op[3:1]==3'b100 ? addr_result :
				       /* else */  arithmetic_result;

endmodule







