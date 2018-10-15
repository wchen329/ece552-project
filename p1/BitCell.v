/* A bit-cell.
 * 
 * wchen329@wisc.edu 
 */
module BitCell(input clk, input rst, input D, input WriteEnable, input ReadEnable1, ReadEnable2, inout Bitline1, inout Bitline2);

	// Encapsulate D Flip Flop
	wire dff_state;
	wire dff_in;
	wire dff_out;
	wire dff_write_en;
	dff STATE_ELEMENT(dff_out, D, WriteEnable, clk, rst);
	
	// Assign read signals
	assign Bitline1 = ReadEnable1 == 0 ? 'z : dff_out;
	assign Bitline2 = ReadEnable2 == 0 ? 'z : dff_out;

endmodule