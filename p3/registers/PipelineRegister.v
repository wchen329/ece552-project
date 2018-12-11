module PipelineRegister(
    clk, rst, we, flush,

    hlt_in, RFwe_in, DataWE_in, ALU1Src_in, ALU2Src_in,
    hlt_ou, RFwe_ou, DataWE_ou, ALU1Src_ou, ALU2Src_ou,
    inst_in, pc_in,
    inst_ou, pc_ou,
    flag_in, flagwe_in,
    flag_ou, flagwe_ou,
    RFdst_in,
    RFdst_ou,

    gppr1_in, gppr2_in,
    gppr1_ou, gppr2_ou,
    gppr3_in, gppr4_in,
    gppr3_ou, gppr4_ou
);
    input clk, rst, we, flush;

    input  hlt_in, RFwe_in, DataWE_in, ALU1Src_in, ALU2Src_in;
    output hlt_ou, RFwe_ou, DataWE_ou, ALU1Src_ou, ALU2Src_ou;
    input [15:0] inst_in, pc_in;
    output[15:0] inst_ou, pc_ou;
    input [2:0]  flag_in, flagwe_in;
    output[2:0]  flag_ou, flagwe_ou;
    input [3:0]  RFdst_in;
    output[3:0]  RFdst_ou;

    input [15:0] gppr1_in, gppr2_in;
    output[15:0] gppr1_ou, gppr2_ou;
    input [3:0]  gppr3_in, gppr4_in;
    output[3:0]  gppr3_ou, gppr4_ou;

    BitCell hlt(.clk(clk), .rst(rst|flush), .D(hlt_in), .WriteEnable(we), .ReadEnable1(1'b1), .ReadEnable2(1'b0), .Bitline1(hlt_ou), .Bitline2());
    BitCell rfwe(.clk(clk), .rst(rst|flush), .D(RFwe_in), .WriteEnable(we), .ReadEnable1(1'b1), .ReadEnable2(1'b0), .Bitline1(RFwe_ou), .Bitline2());
    BitCell DataWE(.clk(clk), .rst(rst|flush), .D(DataWE_in), .WriteEnable(we), .ReadEnable1(1'b1), .ReadEnable2(1'b0), .Bitline1(DataWE_ou), .Bitline2());
    BitCell ALU1Src(.clk(clk), .rst(rst|flush), .D(ALU1Src_in), .WriteEnable(we), .ReadEnable1(1'b1), .ReadEnable2(1'b0), .Bitline1(ALU1Src_ou), .Bitline2());
    BitCell ALU2Src(.clk(clk), .rst(rst|flush), .D(ALU2Src_in), .WriteEnable(we), .ReadEnable1(1'b1), .ReadEnable2(1'b0), .Bitline1(ALU2Src_ou), .Bitline2());

    Register_3bit flag(.clk(clk), .rst(rst|flush), .D(flag_in), .WriteReg(we), .ReadEnable1(1'b1), .ReadEnable2(1'b0), .Bitline1(flag_ou), .Bitline2());
    Register_3bit flagwe(.clk(clk), .rst(rst|flush), .D(flagwe_in), .WriteReg(we), .ReadEnable1(1'b1), .ReadEnable2(1'b0), .Bitline1(flagwe_ou), .Bitline2());

	Register_4bit RFdst(.clk(clk), .rst(rst|flush), .D(RFdst_in), .WriteReg(we), .ReadEnable1(1'b1), .ReadEnable2(1'b0), .Bitline1(RFdst_ou), .Bitline2());
    Register_4bit gppr3(.clk(clk), .rst(rst|flush), .D(gppr3_in), .WriteReg(we), .ReadEnable1(1'b1), .ReadEnable2(1'b0), .Bitline1(gppr3_ou), .Bitline2());
    Register_4bit gppr4(.clk(clk), .rst(rst|flush), .D(gppr4_in), .WriteReg(we), .ReadEnable1(1'b1), .ReadEnable2(1'b0), .Bitline1(gppr4_ou), .Bitline2());

    Register inst(.clk(clk), .rst(rst), .D(flush?16'h2000 :inst_in), .WriteReg(we), .ReadEnable1(1'b1), .ReadEnable2(1'b0), .Bitline1(inst_ou), .Bitline2());
    Register pc(.clk(clk), .rst(rst|flush), .D(pc_in), .WriteReg(we), .ReadEnable1(1'b1), .ReadEnable2(1'b0), .Bitline1(pc_ou), .Bitline2());
    Register gppr1(.clk(clk), .rst(rst|flush), .D(gppr1_in), .WriteReg(we), .ReadEnable1(1'b1), .ReadEnable2(1'b0), .Bitline1(gppr1_ou), .Bitline2());
    Register gppr2(.clk(clk), .rst(rst|flush), .D(gppr2_in), .WriteReg(we), .ReadEnable1(1'b1), .ReadEnable2(1'b0), .Bitline1(gppr2_ou), .Bitline2());
endmodule