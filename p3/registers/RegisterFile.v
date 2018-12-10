/* A huge register file.
 *
 * wchen329@wisc.edu
 */
module RegisterFile(input clk, input rst, input [3:0] SrcReg1, input[3:0] SrcReg2, input[3:0] DstReg, input WriteReg, input [15:0] DstData, inout [15:0] SrcData1, inout[15:0] SrcData2);

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
	Register REG_0(.clk(clk), .rst(1'b1), .D(DstData), .WriteReg(write_sig_dst[0]), .ReadEnable1(read_sig_r1[0]), .ReadEnable2(read_sig_r2[0]), .Bitline1(read_bus_1), .Bitline2(read_bus_2));
	Register REG_1(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_sig_dst[1]), .ReadEnable1(read_sig_r1[1]), .ReadEnable2(read_sig_r2[1]), .Bitline1(read_bus_1), .Bitline2(read_bus_2));
	Register REG_2(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_sig_dst[2]), .ReadEnable1(read_sig_r1[2]), .ReadEnable2(read_sig_r2[2]), .Bitline1(read_bus_1), .Bitline2(read_bus_2));
	Register REG_3(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_sig_dst[3]), .ReadEnable1(read_sig_r1[3]), .ReadEnable2(read_sig_r2[3]), .Bitline1(read_bus_1), .Bitline2(read_bus_2));
	Register REG_4(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_sig_dst[4]), .ReadEnable1(read_sig_r1[4]), .ReadEnable2(read_sig_r2[4]), .Bitline1(read_bus_1), .Bitline2(read_bus_2));
	Register REG_5(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_sig_dst[5]), .ReadEnable1(read_sig_r1[5]), .ReadEnable2(read_sig_r2[5]), .Bitline1(read_bus_1), .Bitline2(read_bus_2));
	Register REG_6(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_sig_dst[6]), .ReadEnable1(read_sig_r1[6]), .ReadEnable2(read_sig_r2[6]), .Bitline1(read_bus_1), .Bitline2(read_bus_2));
	Register REG_7(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_sig_dst[7]), .ReadEnable1(read_sig_r1[7]), .ReadEnable2(read_sig_r2[7]), .Bitline1(read_bus_1), .Bitline2(read_bus_2));
	Register REG_8(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_sig_dst[8]), .ReadEnable1(read_sig_r1[8]), .ReadEnable2(read_sig_r2[8]), .Bitline1(read_bus_1), .Bitline2(read_bus_2));
	Register REG_9(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_sig_dst[9]), .ReadEnable1(read_sig_r1[9]), .ReadEnable2(read_sig_r2[9]), .Bitline1(read_bus_1), .Bitline2(read_bus_2));
	Register REG_10(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_sig_dst[10]), .ReadEnable1(read_sig_r1[10]), .ReadEnable2(read_sig_r2[10]), .Bitline1(read_bus_1), .Bitline2(read_bus_2));
	Register REG_11(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_sig_dst[11]), .ReadEnable1(read_sig_r1[11]), .ReadEnable2(read_sig_r2[11]), .Bitline1(read_bus_1), .Bitline2(read_bus_2));
	Register REG_12(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_sig_dst[12]), .ReadEnable1(read_sig_r1[12]), .ReadEnable2(read_sig_r2[12]), .Bitline1(read_bus_1), .Bitline2(read_bus_2));
	Register REG_13(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_sig_dst[13]), .ReadEnable1(read_sig_r1[13]), .ReadEnable2(read_sig_r2[13]), .Bitline1(read_bus_1), .Bitline2(read_bus_2));
	Register REG_14(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_sig_dst[14]), .ReadEnable1(read_sig_r1[14]), .ReadEnable2(read_sig_r2[14]), .Bitline1(read_bus_1), .Bitline2(read_bus_2));
	Register REG_15(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_sig_dst[15]), .ReadEnable1(read_sig_r1[15]), .ReadEnable2(read_sig_r2[15]), .Bitline1(read_bus_1), .Bitline2(read_bus_2));


	// Check for need of bypassing
	assign SrcData1 = SrcReg1 == 0 ? 0 :
			rst != 0 ? 0 :
			DstReg == SrcReg1 ?
				WriteReg ? DstData
				: read_bus_1
			: read_bus_1;
	assign SrcData2 = SrcReg2 == 0 ? 0 :
			rst != 0 ? 0 :
			DstReg == SrcReg2 ?
				WriteReg ? DstData
				: read_bus_2
			: read_bus_2;

endmodule
