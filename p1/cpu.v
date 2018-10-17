module cpu(clk, rst_n, hlt, pc);
    input clk, rst_n;
    output hlt;
    output[15:0] pc;

    // control signals
    wire PCwe, RFwe, MemWE, NeedBranch, ALU2Src, A2Src;
    wire[2:0] FLAGwe; // {Z,V,N}
    wire[1:0] DwMUX;

    // PC Register & Instruction Memory
    wire [15:0] newPC;
    wire [15:0] inst;
    wire [15:0] pcPlus2;
    PCRegister pc_reg(.clk(clk), .rst_n(rst_n), .we(PCwe), .P(newPC), .Q(pc));
    CLAdder16 pc_add_2(.A(pc), .B(16'h2), .Sum(pcPlus2));
    memory1c_inst inst_mem(.data_out(inst),
                      .data_in(16'hFFFF),
                      .addr(pc),
                      .enable(1'b1),
                      .wr(1'b0),
                      .clk(clk),
                      .rst(~rst_n));

    // Register File & FLAG register
    wire[15:0] read_data1, read_data2, write_data;
    wire[2:0] newFLAG, FLAG;
    RegisterFile_simple reg_file(.clk(clk),
                          .rst(rst_n),
                          .WriteReg(RFwe),
                          .SrcReg1(inst[7:4]),
                          .SrcReg2(A2Src?inst[11:8]:inst[3:0]),
                          .DstReg(inst[11:8]),
                          .DstData(write_data),
                          .SrcData1(read_data1),
                          .SrcData2(read_data2));
    FlagRegister flag_reg(.clk(clk),
                          .rst_n(rst_n),
                          .we(FLAGwe),
                          .flag_in(newFLAG),
                          .flag_out(FLAG));

    // ALU & ByteLoader & MemAddressUnit
    wire[15:0] ALUout, BL, MemAddr;
    MemAddrUnit mem_addr_unit(.baseAddr(read_data1), .offset(inst[3:0]), .memAddr(MemAddr));
    ByteLoader byte_loader(.in(read_data2), .u(inst[7:0]), .high(inst[12]), .out(BL));
    ALU alu(.A(read_data1),
            .B(ALU2Src?{12'b0, inst[3:0]}:read_data2),
            .op(inst[14:12]),
            .out(ALUout),
            .flags(newFLAG));

    // Data memory
    wire[15:0] MEMout;
    memory1c_data data_mem(.data_out(MEMout),
                      .data_in(read_data2),
                      .addr(MemAddr),
                      .enable(1'b1),
                      .wr(MemWE),
                      .clk(clk),
                      .rst(~rst_n));

    // RegisterFile write back
    assign write_data = (DwMUX == 2'b00) ? ALUout :
                        (DwMUX == 2'b01) ? MEMout :
                        (DwMUX == 2'b10) ? BL :
                        (DwMUX == 2'b11) ? pcPlus2 : 16'h0;

    // Control Unit
    ControlUnit ctrl_unit(.opcode(inst[15:12]),
                          .HLT(hlt),
                          .PCwe(PCwe),
                          .RFwe(RFwe),
                          .MemWE(MemWE),
                          .FLAGwe(FLAGwe),
                          .NeedBranch(NeedBranch),
                          .ALU2Src(ALU2Src),
                          .A2Src(A2Src),
                          .DwMUX(DwMUX));

    // PC control
    PC_control_toplevel pc_control(.Branch_Inst(NeedBranch),
                                   .Register_In(inst[12]),
                                   .Rs_In(read_data1),
                                   .C(inst[11:9]),
                                   .Imm(inst[8:0]),
                                   .Flags(FLAG),
                                   .current_PC(pc),
                                   .next_PC(newPC));
endmodule