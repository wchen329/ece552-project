/* A simple 16 bit XOR
 *
 * wchen329@wisc.edu
 */
module xor_16bit(Output, In_One, In_Two);
	input [15:0] In_One, In_Two;
	output [15:0] Output;

	assign Output = In_One ^ In_Two;

endmodule