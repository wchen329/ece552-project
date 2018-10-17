/* An array of 4 carry-look-ahead adders
 * which perform four half byte additions simultaneously.
 *
 * wchen329@wisc.edu
 */
module PADDSB_16bit_cla(Sum, A, B);
	output [15:0] Sum;
	input [15:0] A, B;

	// Calculate word sums, saturation is handled down one level
	addsub_4bit_cla HB_0(Sum[3:0], A[3:0], B[3:0], 1'b0);
	addsub_4bit_cla HB_1(Sum[7:4], A[7:4], B[7:4], 1'b0);
	addsub_4bit_cla HB_2(Sum[11:8], A[11:8], B[11:8], 1'b0);
	addsub_4bit_cla HB_3(Sum[15:12], A[15:12], B[15:12], 1'b0);

endmodule