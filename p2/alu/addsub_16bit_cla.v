/* A four bit word adder/subtractor, CLA.
 * Instead of overflowing, will saturate at the largest value
 * if the result is too large or the smallest value is the result
 * is too small.
 * Enabling the sub flag is simply the same as adding -B instead of B.
 *
 * wchen329@wisc.edu
 */
module addsub_4bit_cla(Sum, A, B, Sub);

	output[3:0] Sum;
	input[3:0] A, B;
	input Sub;

	wire [3:0] B_1s; // 1's complement of B
	wire [3:0] sum_add; // result of A + B
	wire [3:0] sum_sub; // result of A + (-B)
	wire [3:0] Sum_non_sat; // output for no saturation

	// Find(B - 1), the one's complement of B
	assign B_1s = ~ B;

	// Now evaluate addition and subtraction
	adder_4bit_cla_simple ADD( , , sum_add, A, B, 1'b0);
	adder_4bit_cla_simple SUB( , , sum_sub, A, B_1s, 1'b1);

	// Choose non sat output based off of sub flag;
	assign Sum_non_sat = Sub == 0 ? sum_add : sum_sub;

	// Now multiplex output depending on whether saturation occurred or not
	assign Sum =
		Sub == 0 ?
			A[3] == B[3] ?
				A[3] == Sum_non_sat[3] ? Sum_non_sat
					: Sum_non_sat[3] == 0 ? 4'b1000
						: 4'b0111
			: Sum_non_sat
		:

			A[3] != B[3] ?
				A[3] == Sum_non_sat[3] ? Sum_non_sat
					: Sum_non_sat[3] == 0 ? 4'b1000
						: 4'b0111
			: Sum_non_sat
		;

endmodule

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
