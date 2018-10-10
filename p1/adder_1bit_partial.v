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