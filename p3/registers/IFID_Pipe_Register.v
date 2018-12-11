/* The pipeline register specifically for IFID
 *
 * The reset signal is active high.
 *
 * wchen329@wisc.edu
 */
module IFID_Pipe_Register(input clk, input rst, input WE, input flush, input [15:0] inst_next, output[15:0] inst, input[15:0] pc_in, output[15:0] pc_out);
	// xor $0, $0, $0 is the bubble instruction
	Register IFID(.clk(clk), .rst(rst), .D(flush?16'h2000:inst_next), .WriteReg(WE), .ReadEnable1(1'b1), .ReadEnable2(1'b0), .Bitline1(inst), .Bitline2());
	Register IFID2(.clk(clk), .rst(rst), .D(flush?16'h0000:pc_in), .WriteReg(WE), .ReadEnable1(1'b1), .ReadEnable2(1'b0), .Bitline1(pc_out), .Bitline2());
endmodule
