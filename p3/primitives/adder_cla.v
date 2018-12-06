// CLA by Winor Chen

/* One bit Carry Lookahead Adder Unit.
 *
 * wchen329@wisc.edu
 */
module adder_1bit_cla_unit(Propagate, Generate, A, B);
	output Propagate, Generate;
	input A, B;

	assign Propagate = A | B;
	assign Generate = A & B;
endmodule

/* One bit adder with no carry out.
 *
 * wchen329@wisc.edu
 */
module adder_1bit_partial(Sum, A, B, Cin);
	output Sum;
	input A, B, Cin;
	wire A_xor_B;

	assign A_xor_B = ((~A & B) | (A & ~B));
	assign Sum = (~A_xor_B & Cin) | (A_xor_B & ~Cin);

endmodule

/* A simple four-bit Carry-Lookahead Adder which doesn't
 * do anything but add four bits and a carry-in
 * to produce a four-bit result. Also calculates the propagate and generate using Carry-Look-Ahead Logic
 * so it could connect to other adder_4bit_cla_simple
 *
 * wchen329@wisc.edu
 */
module adder_4bit_cla_simple(Propagate, Generate, Sum, A, B, Cin);

	output[3:0] Sum;
	output Propagate, Generate;
	input [3:0] A, B;
	input Cin;

	// Propagate and Generate signals
	wire [3:0] p, g;
	wire msb_cin, msb_cout, msb_pos_cin;

	adder_1bit_cla_unit SIG_0(p[0], g[0], A[0], B[0]);
	adder_1bit_cla_unit SIG_1(p[1], g[1], A[1], B[1]);
	adder_1bit_cla_unit SIG_2(p[2], g[2], A[2], B[2]);
	adder_1bit_cla_unit SIG_3(p[3], g[3], A[3], B[3]);

	// Add
	adder_1bit_partial SUM_0(Sum[0], A[0], B[0], Cin);
	adder_1bit_partial SUM_1(Sum[1], A[1], B[1], g[0] | (p[0] & Cin));
	adder_1bit_partial SUM_2(Sum[2], A[2], B[2], g[1] | (p[1] & (g[0] | (p[0] & Cin))));
	adder_1bit_partial SUM_3(Sum[3], A[3], B[3], g[2] | (p[2] & (g[1] | (p[1] & (g[0] | (p[0] & Cin))))));

	// Calculate Generate
	assign Generate = (A[3] & B[3]) | ((A[3] | B[3]) & ((A[2] & B[2]) | ((A[2] | B[2]) & ((A[1] & B[1]) | ((A[1] | B[1]) & (A[0] & B[0]))))));

	// Calculate Propagate
	assign Propagate = Generate | ((A[0] | B[0]) & (A[1] | B[1]) & (A[2] | B[2]) & (A[3] | B[3]));

endmodule

/* A simple 8-bit carry look ahead adder
 * Only adds.
 *
 * wchen329@wisc.edu
 */
module adder_8bit_cla_simple(Sum, A, B);
	output [7:0] Sum;
	input [7:0] A, B;

	// The propagate and generate signal for each block
	wire [1:0] p, g;

	// Add A, B together, calculate operation
	adder_4bit_cla_simple BLOCK_0 (p[0], g[0], Sum[3:0], A[3:0], B[3:0], 1'b0);
	adder_4bit_cla_simple BLOCK_1 (p[1], g[1], Sum[7:4], A[7:4], B[7:4], g[0]);

endmodule

/* A simple 16-bit carry look ahead adder
 * Only adds.
 *
 * wchen329@wisc.edu
 */
module adder_16bit_cla_simple(Sum, A, B);
	output [15:0] Sum;
	input [15:0] A, B;

	// The propagate and generate signal for each block
	wire [3:0] p, g;

	// Add A, B together, calculate operation
	adder_4bit_cla_simple BLOCK_0 (p[0], g[0], Sum[3:0], A[3:0], B[3:0], 1'b0);
	adder_4bit_cla_simple BLOCK_1 (p[1], g[1], Sum[7:4], A[7:4], B[7:4], g[0]);
	adder_4bit_cla_simple BLOCK_2 (p[2], g[2], Sum[11:8], A[11:8], B[11:8], g[1] | (p[1] & (g[0] )));
	adder_4bit_cla_simple BLOCK_3 (, g[3], Sum[15:12], A[15:12], B[15:12], g[2] | (p[2] & (g[1] | (p[1] & (g[0])))));

endmodule