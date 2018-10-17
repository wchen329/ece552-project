/* A huge register file.
 * No bypassing of any kind.
 *
 * Register 0 is the zero register.
 *
 * wchen329@wisc.edu
 */
module RegisterFile_simple(input clk, input rst, input [3:0] SrcReg1, input[3:0] SrcReg2, input[3:0] DstReg, input WriteReg, input [15:0] DstData, inout [15:0] SrcData1, inout[15:0] SrcData2);

	// Decoder Outputs
	wire[15:0] read_sig_r1;
	wire[15:0] read_sig_r2;
	wire[15:0] write_sig_dst;
	wire[15:0] read_bus_1;
	wire[15:0] read_bus_2;


	// Decoders
	ReadDecoder_4_16 SIG_R1(SrcReg1,  read_sig_r1);
	ReadDecoder_4_16 SIG_R2(SrcReg2,  read_sig_r2);
	WriteDecoder_4_16 SIG_DST(DstReg, WriteReg, write_sig_dst);

	// 16 Registers

	Register REG_0(clk, 1'b1, DstData, write_sig_dst[0], read_sig_r1[0], read_sig_r2[0], read_bus_1, read_bus_2);
	Register REG_1(clk, rst, DstData, write_sig_dst[1], read_sig_r1[1], read_sig_r2[1], read_bus_1, read_bus_2);
	Register REG_2(clk, rst, DstData, write_sig_dst[2], read_sig_r1[2], read_sig_r2[2], read_bus_1, read_bus_2);
	Register REG_3(clk, rst, DstData, write_sig_dst[3], read_sig_r1[3], read_sig_r2[3], read_bus_1, read_bus_2);
	Register REG_4(clk, rst, DstData, write_sig_dst[4], read_sig_r1[4], read_sig_r2[4], read_bus_1, read_bus_2);
	Register REG_5(clk, rst, DstData, write_sig_dst[5], read_sig_r1[5], read_sig_r2[5], read_bus_1, read_bus_2);
	Register REG_6(clk, rst, DstData, write_sig_dst[6], read_sig_r1[6], read_sig_r2[6], read_bus_1, read_bus_2);
	Register REG_7(clk, rst, DstData, write_sig_dst[7], read_sig_r1[7], read_sig_r2[7], read_bus_1, read_bus_2);
	Register REG_8(clk, rst, DstData, write_sig_dst[8], read_sig_r1[8], read_sig_r2[8], read_bus_1, read_bus_2);
	Register REG_9(clk, rst, DstData, write_sig_dst[9], read_sig_r1[9], read_sig_r2[9], read_bus_1, read_bus_2);
	Register REG_10(clk, rst, DstData, write_sig_dst[10], read_sig_r1[10], read_sig_r2[10], read_bus_1, read_bus_2);
	Register REG_11(clk, rst, DstData, write_sig_dst[11], read_sig_r1[11], read_sig_r2[11], read_bus_1, read_bus_2);
	Register REG_12(clk, rst, DstData, write_sig_dst[12], read_sig_r1[12], read_sig_r2[12], read_bus_1, read_bus_2);
	Register REG_13(clk, rst, DstData, write_sig_dst[13], read_sig_r1[13], read_sig_r2[13], read_bus_1, read_bus_2);
	Register REG_14(clk, rst, DstData, write_sig_dst[14], read_sig_r1[14], read_sig_r2[14], read_bus_1, read_bus_2);
	Register REG_15(clk, rst, DstData, write_sig_dst[15], read_sig_r1[15], read_sig_r2[15], read_bus_1, read_bus_2);

	assign SrcData1 = read_bus_1;
	assign SrcData2 = read_bus_2;

endmodule
