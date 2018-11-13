/* A 6-bit register.
 *
 * wchen329@wisc.edu
 */
module Register_6bit(input clk, input rst, input [15:0] D, input WriteReg, input ReadEnable1, input ReadEnable2, inout[5:0] Bitline1, inout [5:0] Bitline2);
	BitCell CELL_0(clk, rst, D[0], WriteReg, ReadEnable1, ReadEnable2, Bitline1[0], Bitline2[0]);
	BitCell CELL_1(clk, rst, D[1], WriteReg, ReadEnable1, ReadEnable2, Bitline1[1], Bitline2[1]);
	BitCell CELL_2(clk, rst, D[2], WriteReg, ReadEnable1, ReadEnable2, Bitline1[2], Bitline2[2]);
	BitCell CELL_3(clk, rst, D[3], WriteReg, ReadEnable1, ReadEnable2, Bitline1[3], Bitline2[3]);
	BitCell CELL_4(clk, rst, D[4], WriteReg, ReadEnable1, ReadEnable2, Bitline1[4], Bitline2[4]);
	BitCell CELL_5(clk, rst, D[5], WriteReg, ReadEnable1, ReadEnable2, Bitline1[5], Bitline2[5]);

endmodule
