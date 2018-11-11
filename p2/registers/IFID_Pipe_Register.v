/* The pipeline register specifically for IFID
 *
 * The reset signal is active high.
 *
 * wchen329@wisc.edu
 */
module IFID_Pipe_Register(input clk, input rst, input [15:0] inst_next, output[15:0] inst);

	Register IFID(.clk(clk), .rst(rst), .D(inst_next), .WriteReg(1), .ReadEnable1(1), .ReadEnable2(0), .Bitline1(inst));
endmodule
