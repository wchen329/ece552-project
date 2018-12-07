/* FSM specifically for finding correct LRU
 *
 * An implicit assumption here is held- LRU reading starts from block 0 then
 * moves to block 1.
 *
 * wchen329@wisc.edu
 */
module LRU_MissHandler_FSM(clk, rst, LRU_in, current_way, result_ready, correct_way);

	input clk;
	input rst;
	input LRU_in;		// input LRU value from read
	input current_way;	// the way currently being analyzed by the toplevel

	output result_ready;	// is the LRU decision ready or no?
	output correct_way;	// when ready, this is the correct block / way / line / edge in a set to modify

	wire LRU_BL1_out;	// LRU value of block 1
	wire LRU_BL0_out;	// LRU value of block 0


	// State elements of this FSM
	BitCell LRU_BL0(.clk(clk), .rst(rst), .D(LRU_in), .WriteEnable(~current_way), .ReadEnable1(1'b1), .Bitline1(LRU_BL0_out));

	// Assign wires and outputs
	assign result_ready = current_way == 1 ? 1 : 0;
	assign LRU_BL1_out = current_way == 1 ? LRU_in : 0;

	assign correct_way = LRU_BL0_out == 0 ? 0 : // always fill from edge 0 if completely cold
				LRU_BL1_out == 0 ? 1 : 0;

endmodule
