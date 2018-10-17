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