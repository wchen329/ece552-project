/* An array of 4 carry-look-ahead adders
 * which perform four half byte additions simultaneously.
 *
 * wchen329@wisc.edu
 */
module PADDSB_16bit_cla(Sum, A, B);
	output [15:0] Sum;
	input [15:0] A, B;

	// Calculate word sums, saturation is handled down one level
	addsub_4bit_cla HB_0(.Sum(Sum[3:0]), .A(A[3:0]), .B(B[3:0]), .Sub(1'b0));
	addsub_4bit_cla HB_1(.Sum(Sum[7:4]), .A(A[7:4]), .B(B[7:4]), .Sub(1'b0));
	addsub_4bit_cla HB_2(.Sum(Sum[11:8]), .A(A[11:8]), .B(B[11:8]), .Sub(1'b0));
	addsub_4bit_cla HB_3(.Sum(Sum[15:12]), .A(A[15:12]), .B(B[15:12]), .Sub(1'b0));

endmodule