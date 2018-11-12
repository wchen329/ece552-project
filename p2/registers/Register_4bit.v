/* A 4-bit register.
 *
 * wchen329@wisc.edu
 */
module Register_4bit(input clk, input rst, input [3:0] D, input WriteReg, input ReadEnable1, input ReadEnable2, inout[3:0] Bitline1, inout [3:0] Bitline2);
	BitCell CELL_0(clk, rst, D[0], WriteReg, ReadEnable1, ReadEnable2, Bitline1[0], Bitline2[0]);
	BitCell CELL_1(clk, rst, D[1], WriteReg, ReadEnable1, ReadEnable2, Bitline1[1], Bitline2[1]);
	BitCell CELL_2(clk, rst, D[2], WriteReg, ReadEnable1, ReadEnable2, Bitline1[2], Bitline2[2]);
	BitCell CELL_3(clk, rst, D[3], WriteReg, ReadEnable1, ReadEnable2, Bitline1[3], Bitline2[3]);
endmodule 
