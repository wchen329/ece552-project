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