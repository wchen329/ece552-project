module cpu(clk, rst_n, hlt, pc);
    input clk, rst_n;
    output hlt;
    output[15:0] pc;

    wire rst;
    assign rst = ~rst_n;
    assign hlt = wb_hlt;

    // all decl
    wire flush, taken, stall, pc_we;

    wire [15:0] if_inst;

    wire [15:0] id_pc, id_inst;
    wire [2:0] id_flagout, id_forwardedFlag;
    wire[3:0] id_RFsrc1, id_RFsrc2;
    wire[15:0] id_RFout1, id_RFout2;
    wire[15:0] id_forwardedBranchRegisterTarget;
    wire[1:0] id_brForwardSel;
    wire [3:0] id_aluSrc1, id_aluSrc2;
    wire id_RFwe, id_DataWe, id_ALU1Src, id_ALU2Src, id_hlt, id_A2Src;
    wire [2:0] id_flagwe;
    wire [3:0] id_RFdst;


    wire[15:0] ex_RFout1, ex_RFout2, ex_inst, ex_alu1, ex_alu2, ex_aluout;
    wire[3:0] ex_RFsrc1, ex_RFsrc2, ex_aluSrc1, ex_aluSrc2, ex_RFdst;
    wire[1:0] ex_sel1, ex_sel2;
    wire ex_ALU1Src; // 0=from RFout1; 1=from RFout2
    wire ex_ALU2Src; // 0=from RFout2; 1=inst[3:0]
    wire [2:0] ex_aluFlagZVN, ex_flagwe;
    wire ex_RFwe, ex_DataWe, ex_hlt;
    wire[15:0] ex_pc, ex_resultToPR;


    wire mem_DataWe, mem_UseAluResult, mem_RFwe, mem_hlt;
    wire[15:0] mem_DataAddr, mem_inst;
    wire[15:0] mem_DataWriteData, mem_DataWriteDataFromPR, mem_DataReadData, mem_AluResult;
    wire[3:0] mem_DataWriteSrcReg, mem_RFdst;
    wire[2:0] mem_flag, mem_flagwe;
    wire mem_MemMemForwarding;
    wire[15:0] mem_DataToBeWrittenToPR;

    wire wb_RFwe, wb_hlt;
    wire[3:0] wb_RFdst;
    wire[15:0] wb_RFwriteData;
    wire[2:0] wb_flag, wb_flagwe;

    // IF stage
    assign flush = taken;
    wire [15:0] pcTarget, pcPlus2;
    CLAdder16 add0(pc, 16'h2, pcPlus2);
    PCRegister pcRegister(.clk(clk), .rst(rst), .we(pc_we & ~stall), .P(taken?pcTarget:pcPlus2), .Q(pc));
    InstMemory instMem(.clk(clk), .rst(rst), .enable(1'b1), .wr(1'b0), .addr(pc), .data_out(if_inst), .data_in(16'h0));
    IFID_Pipe_Register IFID_PR(.clk(clk), .rst(rst), .WE(pc_we & ~stall), .flush(flush), .inst_next(if_inst), .inst(id_inst), .pc_in(pc), .pc_out(id_pc));

    // ID stage, including all the control stuff
    FlagRegister flagRegister(.clk(clk), .rst(rst), .weZVN(wb_flagwe), .flagZVN_in(wb_flag), .flagZVN_out(id_flagout));
    flagZVN_forwarding_mux flagForwardingLogic(
        .ALU_flagZVN(ex_aluFlagZVN), .IDEX_flagZVN_we(ex_flagwe),
        .EXMEM_flagZVN(mem_flag), .EXMEM_flagZVN_we(mem_flagwe),
        .FR_flagZVN(id_flagout), .flagZVN_out(id_forwardedFlag));

    assign id_RFsrc1 = id_inst[7:4];
    assign id_RFsrc2 = id_A2Src ? id_inst[3:0] : id_inst[11:8];
    RegisterFile registerFile(.clk(clk), .rst(rst), .SrcReg1(id_RFsrc1), .SrcReg2(id_RFsrc2), .DstReg(wb_RFdst), .WriteReg(wb_RFwe), .DstData(wb_RFwriteData), .SrcData1(id_RFout1), .SrcData2(id_RFout2));

    ForwardToBranchRegister forwardBr(.brSrcSel(id_brForwardSel), .brSrc(id_RFsrc1), .aluDst(ex_RFdst), .exDst(mem_RFdst), .willAluWrite(ex_RFwe), .willExWrite(mem_RFwe));
    assign id_forwardedBranchRegisterTarget = id_brForwardSel==2'b01 ? ex_resultToPR :
                                              id_brForwardSel==2'b10 ? mem_AluResult : id_RFout1 ;

    assign id_aluSrc1 = id_ALU1Src ? id_RFsrc1 : id_RFsrc2;
    assign id_aluSrc2 = id_ALU2Src ? id_RFsrc2 : 4'b0000;
    HazardController stallingController(
        .stall(stall),
        .aluSrc1(id_aluSrc1), .aluSrc2(id_aluSrc2), .brSrc(id_RFsrc1),
        .lwDst(ex_RFdst), .willWrite(ex_inst[15:12]==4'b1000),
        .isBr(id_inst[15:12]==4'b1101), .isUnconditional(id_inst[15:9]==7'b1101111));

    PC_Control pcCtrl(.opcode(id_inst[15:12]), .condition(id_inst[11:9]), .flagZVN(id_forwardedFlag),
        .offset(id_inst[8:0]), .target_reg(id_forwardedBranchRegisterTarget),
        .PC_in(id_pc), .taken(taken), .PC_out(pcTarget));


    assign id_RFdst = id_inst[11:8];
    ControlUnit ctrl(.opcode(id_inst[15:12]), .HLT(id_hlt),
        .PCwe(pc_we), .RFwe(id_RFwe), .MemWE(id_DataWe), .FLAGwe(id_flagwe),
        .ALU2Src(id_ALU2Src), .A2Src(id_A2Src));
    assign id_ALU1Src = id_inst[15:13] == 3'b101;


    PipelineRegister idex(
        .clk(clk), .rst(rst), .we(1'b1), .flush(stall),
        .hlt_in(id_hlt), .hlt_ou(ex_hlt),
        .RFwe_in(id_RFwe), .RFwe_ou(ex_RFwe),
        .RFdst_in(id_RFdst), .RFdst_ou(ex_RFdst),
        .flagwe_in(id_flagwe), .flagwe_ou(ex_flagwe),
        .DataWE_in(id_DataWe), .DataWE_ou(ex_DataWe),
        .inst_in(id_inst), .inst_ou(ex_inst),
        .pc_in(id_pc), .pc_ou(ex_pc),
        .ALU1Src_in(id_ALU1Src), .ALU1Src_ou(ex_ALU1Src),
        .ALU2Src_in(id_ALU2Src), .ALU2Src_ou(ex_ALU2Src),
        .gppr1_in(id_RFout1), .gppr1_ou(ex_RFout1),
        .gppr2_in(id_RFout2), .gppr2_ou(ex_RFout2),
        .gppr3_in(id_RFsrc1), .gppr3_ou(ex_RFsrc1),
        .gppr4_in(id_RFsrc2), .gppr4_ou(ex_RFsrc2)
    );

    // EX stage

    assign ex_alu1    = ex_ALU1Src ? ex_RFout1 : ex_RFout2;
    assign ex_alu2    = ex_ALU2Src ? ex_RFout2 : ex_inst;
    assign ex_aluSrc1 = ex_ALU1Src ? ex_RFsrc1 : ex_RFsrc2;
    assign ex_aluSrc2 = ex_ALU2Src ? ex_RFsrc2 : 4'b0000;

    ForwardToALU forwardAlu1(.aluSrcSel(ex_sel1), .aluSrc(ex_aluSrc1), .exDst(mem_RFdst), .memDst(wb_RFdst), .willExWrite(mem_UseAluResult & mem_RFwe), .willMemWrite(wb_RFwe));
    ForwardToALU forwardAlu2(.aluSrcSel(ex_sel2), .aluSrc(ex_aluSrc2), .exDst(mem_RFdst), .memDst(wb_RFdst), .willExWrite(mem_UseAluResult & mem_RFwe), .willMemWrite(wb_RFwe));

    ALU alu(.A(ex_sel1==2'b01 ?mem_AluResult:ex_sel1==2'b10 ?wb_RFwriteData:ex_alu1),
            .B(ex_sel2==2'b01 ?mem_AluResult:ex_sel2==2'b10 ?wb_RFwriteData:ex_alu2),
            .op(ex_inst[15:12]), .out(ex_aluout), .flagZVN(ex_aluFlagZVN));

    assign ex_resultToPR = (ex_inst[15:12]==4'b1110) ? ex_pc : ex_aluout;

    PipelineRegister exmem(
        .clk(clk), .rst(rst), .we(1'b1), .flush(1'b0),
        .hlt_in(ex_hlt), .hlt_ou(mem_hlt),
        .RFwe_in(ex_RFwe), .RFwe_ou(mem_RFwe),
        .RFdst_in(ex_RFdst), .RFdst_ou(mem_RFdst),
        .flag_in(ex_aluFlagZVN), .flag_ou(mem_flag),
        .flagwe_in(ex_flagwe), .flagwe_ou(mem_flagwe),
        .DataWE_in(ex_DataWe), .DataWE_ou(mem_DataWe),
        .inst_in(ex_inst), .inst_ou(mem_inst),
        .gppr1_in(ex_resultToPR), .gppr1_ou(mem_AluResult),
        .gppr2_in(ex_RFout2), .gppr2_ou(mem_DataWriteDataFromPR)
    );

    // MEM stage
    assign mem_DataAddr = mem_AluResult;
    ForwardToMem forwardToMem(.memSrcSel(mem_MemMemForwarding), .memSrc(mem_DataWriteSrcReg), .wbDst(wb_RFdst), .willWrite(wb_RFwe));
    assign mem_DataWriteData = mem_MemMemForwarding ? wb_RFwriteData : mem_DataWriteDataFromPR;
    DataMemory dataMemory(.clk(clk), .rst(rst), .enable(1'b1), .wr(mem_DataWe), .addr(mem_DataAddr), .data_in(mem_DataWriteData), .data_out(mem_DataReadData));

    assign mem_UseAluResult = mem_inst[15:12] != 4'b1000;
    assign mem_DataToBeWrittenToPR = mem_UseAluResult ? mem_AluResult : mem_DataReadData;

    PipelineRegister memwb(
        .clk(clk), .rst(rst), .we(1'b1), .flush(1'b0),
        .hlt_in(mem_hlt), .hlt_ou(wb_hlt),
        .RFwe_in(mem_RFwe), .RFwe_ou(wb_RFwe),
        .RFdst_in(mem_RFdst), .RFdst_ou(wb_RFdst),
        .gppr1_in(mem_DataToBeWrittenToPR), .gppr1_ou(wb_RFwriteData),
        .flag_in(mem_flag), .flag_ou(wb_flag),
        .flagwe_in(mem_flagwe), .flagwe_ou(wb_flagwe)
    );
endmodule