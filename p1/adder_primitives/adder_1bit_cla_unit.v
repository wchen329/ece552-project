/* One bit Carry Lookahead Adder Unit.
 *
 * wchen329@wisc.edu
 */
module adder_1bit_cla_unit(Propagate, Generate, A, B);
	output Propagate, Generate;
	input A, B;

	assign Propagate = A | B;
	assign Generate = A & B;
endmodule