/* An interface for an ALU
 * This one does not implement checks of any kind.
 *
 * wchen329@wisc.edu
 */
module ALU(A, B, op, out, flags);

	output [15:0] out;
	output [2:0] flags;
	input [15:0] A, B;
	input [2:0] op;

	ALU_no_check ALU_INST(A, B, op, out, flags);

endmodule
