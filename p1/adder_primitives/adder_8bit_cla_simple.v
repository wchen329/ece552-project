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