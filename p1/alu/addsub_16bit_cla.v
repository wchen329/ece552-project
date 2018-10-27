/* A 16-bit carry look ahead adder for ADD/SUB
 * implements saturation.
 *
 * Sets an "Overflow" flag when saturation occurs.
 *
 * wchen329@wisc.edu
 */
module addsub_16bit_cla(Sum, Ovfl, A, B, Sub);
	output [15:0] Sum;
	output Ovfl;
	input [15:0] A, B;
	input Sub;

	// The propagate and generate signal for each block
	wire [3:0] p, g, p_neg, g_neg;
	wire Cin_operating;

	// Intermediate Sums
	wire [15:0] B_operating, Inter_Sum;

	assign B_operating = Sub == 0 ? B : ~B;
	assign Cin_operating = Sub == 0 ? 0 : 1;


	// Add A, B together, calculate operation
	adder_4bit_cla_simple BLOCK_0 (p[0], g[0], Inter_Sum[3:0], A[3:0], B_operating[3:0], Cin_operating);
	adder_4bit_cla_simple BLOCK_1 (p[1], g[1], Inter_Sum[7:4], A[7:4], B_operating[7:4], g[0] | (p[0] & Cin_operating));
	adder_4bit_cla_simple BLOCK_2 (p[2], g[2], Inter_Sum[11:8], A[11:8], B_operating[11:8], g[1] | (p[1] & (g[0] | (p[0] & Cin_operating))));
	adder_4bit_cla_simple BLOCK_3 (, g[3], Inter_Sum[15:12], A[15:12], B_operating[15:12], g[2] | (p[2] & (g[1] | (p[1] & (g[0] | (p[0] & Cin_operating))))));

	// Now multiplex output depending on whether saturation occurred or not
	assign Sum =
		Sub == 0 ?
			A[15] == B[15] ?
				A[15] == Inter_Sum[15] ? Inter_Sum
				: Inter_Sum[15] == 0 ? 16'b1000000000000000
					: 16'b0111111111111111
			: Inter_Sum

		:
		// Sub == 1
			A[15] != B[15] ?
				A[15] == Inter_Sum[15] ? Inter_Sum
				: Inter_Sum[15] == 0 ? 16'b1000000000000000
					: 16'b0111111111111111
			: Inter_Sum
		;
	
	assign Ovfl =

		Sub == 0 ?
			A[15] == B[15] ?
				A[15] == Inter_Sum[15] ? 0 : 1 
			:0

		:
		// Sub == 1
			A[15] != B[15] ?
				A[15] == Inter_Sum[15] ? 0 : 1
			:0
		;
endmodule
