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