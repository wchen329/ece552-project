/* A 16-bit register.
 *
 * wchen329@wisc.edu
 */
module Register(input clk, input rst, input [15:0] D, input WriteReg, input ReadEnable1, input ReadEnable2, inout[15:0] Bitline1, inout [15:0] Bitline2);
	BitCell CELL_0(clk, rst, D[0], WriteReg, ReadEnable1, ReadEnable2, Bitline1[0], Bitline2[0]);
	BitCell CELL_1(clk, rst, D[1], WriteReg, ReadEnable1, ReadEnable2, Bitline1[1], Bitline2[1]);
	BitCell CELL_2(clk, rst, D[2], WriteReg, ReadEnable1, ReadEnable2, Bitline1[2], Bitline2[2]);
	BitCell CELL_3(clk, rst, D[3], WriteReg, ReadEnable1, ReadEnable2, Bitline1[3], Bitline2[3]);
	BitCell CELL_4(clk, rst, D[4], WriteReg, ReadEnable1, ReadEnable2, Bitline1[4], Bitline2[4]);
	BitCell CELL_5(clk, rst, D[5], WriteReg, ReadEnable1, ReadEnable2, Bitline1[5], Bitline2[5]);
	BitCell CELL_6(clk, rst, D[6], WriteReg, ReadEnable1, ReadEnable2, Bitline1[6], Bitline2[6]);
	BitCell CELL_7(clk, rst, D[7], WriteReg, ReadEnable1, ReadEnable2, Bitline1[7], Bitline2[7]);
	BitCell CELL_8(clk, rst, D[8], WriteReg, ReadEnable1, ReadEnable2, Bitline1[8], Bitline2[8]);
	BitCell CELL_9(clk, rst, D[9], WriteReg, ReadEnable1, ReadEnable2, Bitline1[9], Bitline2[9]);
	BitCell CELL_10(clk, rst, D[10], WriteReg, ReadEnable1, ReadEnable2, Bitline1[10], Bitline2[10]);
	BitCell CELL_11(clk, rst, D[11], WriteReg, ReadEnable1, ReadEnable2, Bitline1[11], Bitline2[11]);
	BitCell CELL_12(clk, rst, D[12], WriteReg, ReadEnable1, ReadEnable2, Bitline1[12], Bitline2[12]);
	BitCell CELL_13(clk, rst, D[13], WriteReg, ReadEnable1, ReadEnable2, Bitline1[13], Bitline2[13]);
	BitCell CELL_14(clk, rst, D[14], WriteReg, ReadEnable1, ReadEnable2, Bitline1[14], Bitline2[14]);
	BitCell CELL_15(clk, rst, D[15], WriteReg, ReadEnable1, ReadEnable2, Bitline1[15], Bitline2[15]);

endmodule 
