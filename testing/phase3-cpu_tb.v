module cpu_ptb();
    wire [15:0] PC;
    wire [15:0] Inst;           /* This should be the 16 bits of the FF that
                                   stores instructions fetched from instruction memory */

    wire        RegWrite;       /* Whether register file is being written to */
    wire [3:0]  WriteRegister;  /* What register is written */
    wire [15:0] WriteData;      /* Data */
    wire        MemWrite;       /* Similar as above but for memory */
    wire        MemRead;
    wire [15:0] MemAddress;
    wire [15:0] MemDataIn;      /* Read from Memory */
    wire [15:0] MemDataOut;     /* Written to Memory */
    wire        DCacheHit;
    wire        ICacheHit;
    wire        DCacheReq;
    wire        ICacheReq;

    wire        Halt;           /* Halt executed and in Memory or writeback stage */

    integer     inst_count;
    integer     cycle_count;

    integer     trace_file;
    integer     sim_log_file;

    integer     DCacheHit_count;
    integer     ICacheHit_count;
    integer     DCacheReq_count;
    integer     ICacheReq_count;

    reg clk;    /* Clock input */
    reg rst_n;  /* (Active low) Reset input */
    cpu DUT(.clk(clk), .rst_n(rst_n), .pc(PC), .hlt(Halt)); /* Instantiate your processor */



    task dumpMemory;
        reg[63:0] i;
        reg[15:0] d,adr;
        integer mem_file;
        begin
            mem_file = $fopen("dumpfile_data.img");
            for (i=0; i < 2**15;i=i+1) begin
                d = DUT.MC.MAIN_MEMORY.mem[i];
                adr = i << 1;
                if (d != 0) begin
                    $fdisplay(mem_file, "%h: %h", adr, d);
                end
            end
            $fdisplay(mem_file, "=== DUMP ENDS ===");
            $fclose(mem_file);
        end
    endtask

    task dumpToplevel;
    begin
        $fdisplay(sim_log_file, "        hlt:%x", DUT.hlt);
        $fdisplay(sim_log_file, "        pc:%x", DUT.pc);
        $fdisplay(sim_log_file, "        flush:%x", DUT.flush);
        $fdisplay(sim_log_file, "        taken:%x", DUT.taken);
        $fdisplay(sim_log_file, "        stall:%x", DUT.stall);
        $fdisplay(sim_log_file, "        pc_we:%x", DUT.pc_we);
        $fdisplay(sim_log_file, "        pcTarget:%x", DUT.pcTarget);
        $fdisplay(sim_log_file, "        pcPlus2:%x", DUT.pcPlus2);
        $fdisplay(sim_log_file, "        if_inst:%x", DUT.if_inst);
        $fdisplay(sim_log_file, "        id_pc:%x", DUT.id_pc);
        $fdisplay(sim_log_file, "        id_inst:%x", DUT.id_inst);
        $fdisplay(sim_log_file, "        id_flagout:%x", DUT.id_flagout);
        $fdisplay(sim_log_file, "        id_forwardedFlag:%x", DUT.id_forwardedFlag);
        $fdisplay(sim_log_file, "        id_RFsrc1:%x", DUT.id_RFsrc1);
        $fdisplay(sim_log_file, "        id_RFsrc2:%x", DUT.id_RFsrc2);
        $fdisplay(sim_log_file, "        id_RFout1:%x", DUT.id_RFout1);
        $fdisplay(sim_log_file, "        id_RFout2:%x", DUT.id_RFout2);
        $fdisplay(sim_log_file, "        id_forwardedBranchRegisterTarget:%x", DUT.id_forwardedBranchRegisterTarget);
        $fdisplay(sim_log_file, "        id_brForwardSel:%x", DUT.id_brForwardSel);
        $fdisplay(sim_log_file, "        id_aluSrc1:%x", DUT.id_aluSrc1);
        $fdisplay(sim_log_file, "        id_aluSrc2:%x", DUT.id_aluSrc2);
        $fdisplay(sim_log_file, "        id_RFwe:%x", DUT.id_RFwe);
        $fdisplay(sim_log_file, "        id_DataWe:%x", DUT.id_DataWe);
        $fdisplay(sim_log_file, "        id_ALU1Src:%x", DUT.id_ALU1Src);
        $fdisplay(sim_log_file, "        id_ALU2Src:%x", DUT.id_ALU2Src);
        $fdisplay(sim_log_file, "        id_hlt:%x", DUT.id_hlt);
        $fdisplay(sim_log_file, "        id_A2Src:%x", DUT.id_A2Src);
        $fdisplay(sim_log_file, "        id_flagwe:%x", DUT.id_flagwe);
        $fdisplay(sim_log_file, "        id_RFdst:%x", DUT.id_RFdst);
        $fdisplay(sim_log_file, "        ex_RFout1:%x", DUT.ex_RFout1);
        $fdisplay(sim_log_file, "        ex_RFout2:%x", DUT.ex_RFout2);
        $fdisplay(sim_log_file, "        ex_inst:%x", DUT.ex_inst);
        $fdisplay(sim_log_file, "        ex_alu1:%x", DUT.ex_alu1);
        $fdisplay(sim_log_file, "        ex_alu2:%x", DUT.ex_alu2);
        $fdisplay(sim_log_file, "        ex_aluout:%x", DUT.ex_aluout);
        $fdisplay(sim_log_file, "        ex_RFsrc1:%x", DUT.ex_RFsrc1);
        $fdisplay(sim_log_file, "        ex_RFsrc2:%x", DUT.ex_RFsrc2);
        $fdisplay(sim_log_file, "        ex_aluSrc1:%x", DUT.ex_aluSrc1);
        $fdisplay(sim_log_file, "        ex_aluSrc2:%x", DUT.ex_aluSrc2);
        $fdisplay(sim_log_file, "        ex_RFdst:%x", DUT.ex_RFdst);
        $fdisplay(sim_log_file, "        ex_sel1:%x", DUT.ex_sel1);
        $fdisplay(sim_log_file, "        ex_sel2:%x", DUT.ex_sel2);
        $fdisplay(sim_log_file, "        ex_ALU1Src:%x", DUT.ex_ALU1Src);
        $fdisplay(sim_log_file, "        ex_ALU2Src:%x", DUT.ex_ALU2Src);
        $fdisplay(sim_log_file, "        ex_aluFlagZVN:%x", DUT.ex_aluFlagZVN);
        $fdisplay(sim_log_file, "        ex_flagwe:%x", DUT.ex_flagwe);
        $fdisplay(sim_log_file, "        ex_RFwe:%x", DUT.ex_RFwe);
        $fdisplay(sim_log_file, "        ex_DataWe:%x", DUT.ex_DataWe);
        $fdisplay(sim_log_file, "        ex_hlt:%x", DUT.ex_hlt);
        $fdisplay(sim_log_file, "        ex_pc:%x", DUT.ex_pc);
        $fdisplay(sim_log_file, "        ex_resultToPR:%x", DUT.ex_resultToPR);
        $fdisplay(sim_log_file, "        mem_DataWe:%x", DUT.mem_DataWe);
        $fdisplay(sim_log_file, "        mem_UseAluResult:%x", DUT.mem_UseAluResult);
        $fdisplay(sim_log_file, "        mem_RFwe:%x", DUT.mem_RFwe);
        $fdisplay(sim_log_file, "        mem_hlt:%x", DUT.mem_hlt);
        $fdisplay(sim_log_file, "        mem_DataAddr:%x", DUT.mem_DataAddr);
        $fdisplay(sim_log_file, "        mem_inst:%x", DUT.mem_inst);
        $fdisplay(sim_log_file, "        mem_DataWriteData:%x", DUT.mem_DataWriteData);
        $fdisplay(sim_log_file, "        mem_DataWriteDataFromPR:%x", DUT.mem_DataWriteDataFromPR);
        $fdisplay(sim_log_file, "        mem_DataReadData:%x", DUT.mem_DataReadData);
        $fdisplay(sim_log_file, "        mem_AluResult:%x", DUT.mem_AluResult);
        $fdisplay(sim_log_file, "        mem_DataWriteSrcReg:%x", DUT.mem_DataWriteSrcReg);
        $fdisplay(sim_log_file, "        mem_RFdst:%x", DUT.mem_RFdst);
        $fdisplay(sim_log_file, "        mem_flag:%x", DUT.mem_flag);
        $fdisplay(sim_log_file, "        mem_flagwe:%x", DUT.mem_flagwe);
        $fdisplay(sim_log_file, "        mem_MemMemForwarding:%x", DUT.mem_MemMemForwarding);
        $fdisplay(sim_log_file, "        mem_DataToBeWrittenToPR:%x", DUT.mem_DataToBeWrittenToPR);
        $fdisplay(sim_log_file, "        wb_RFwe:%x", DUT.wb_RFwe);
        $fdisplay(sim_log_file, "        wb_hlt:%x", DUT.wb_hlt);
        $fdisplay(sim_log_file, "        wb_RFdst:%x", DUT.wb_RFdst);
        $fdisplay(sim_log_file, "        wb_RFwriteData:%x", DUT.wb_RFwriteData);
        $fdisplay(sim_log_file, "        wb_flag:%x", DUT.wb_flag);
        $fdisplay(sim_log_file, "        wb_flagwe:%x", DUT.wb_flagwe);
    end
    endtask





    /* Setup */
    initial begin
        $display("Hello world...simulation starting");
        $display("See verilogsim.plog and verilogsim.ptrace for output");
        inst_count = 0;
        DCacheHit_count = 0;
        ICacheHit_count = 0;
        DCacheReq_count = 0;
        ICacheReq_count = 0;

        trace_file = $fopen("verilogsim.trace");
        sim_log_file = $fopen("verilogsim.log");
        $fdisplay(sim_log_file, "SIMLOG:: Cycle             PC:          I:          R:[WE] [WR] [DATA] M: [R][W]     [Addr]     [In]     [OutFromMem]   PREDICT: [pc] [predict] [taken] [mis] [newtarget]");
    end

    /* Clock and Reset */
    // Clock period is 100 time units, and reset length
    // to 201 time units (two rising edges of clock).
    initial begin
        $dumpvars;
        cycle_count = 0;
        rst_n = 0; /* Intial reset state */
        clk = 1;
        #201 rst_n = 1; // delay until slightly after two clock periods
    end

    always #50 begin   // delay 1/2 clock period each time thru loop
        clk = ~clk;
    end





    /* Stats */
    always @ (posedge clk) begin
        cycle_count = cycle_count + 1;
        if (cycle_count > 100000) begin
            $display("hmm....more than 100000 cycles of simulation...error?\n");
            $finish;
        end

        if (rst_n) begin
            if (Halt || RegWrite || MemWrite) begin
                inst_count = inst_count + 1;
            end
            if (DCacheHit) begin
                DCacheHit_count = DCacheHit_count + 1;
            end
            if (ICacheHit) begin
                ICacheHit_count = ICacheHit_count + 1;
            end
            if (DCacheReq) begin
                DCacheReq_count = DCacheReq_count + 1;
            end
            if (ICacheReq) begin
                ICacheReq_count = ICacheReq_count + 1;
            end

            $fdisplay(sim_log_file, "SIMLOG:: Cycle %d PC: %8x I: %8x R: %d %3d %8x M: %d %d %8x %8x %8x  PREDICT: %8x %8x %1x %1x %8x",
                                    cycle_count,
                                    PC,
                                    Inst,
                                    RegWrite,
                                    WriteRegister,
                                    WriteData,
                                    MemRead,
                                    MemWrite,
                                    MemAddress,
                                    MemDataIn,
                                    MemDataOut,
                                    DUT.pc,
                                    DUT.predictedPc,
                                    DUT.taken,
                                    DUT.mispredicted,
                                    DUT.pcTarget);
            dumpToplevel();
            if (RegWrite) begin
                $fdisplay(trace_file,"REG: %d VALUE: 0x%04x", WriteRegister, WriteData);
            end
            if (MemRead) begin
                $fdisplay(trace_file,"LOAD: ADDR: 0x%04x VALUE: 0x%04x", MemAddress, MemDataOut);
            end
            if (MemWrite) begin
                $fdisplay(trace_file,"STORE: ADDR: 0x%04x VALUE: 0x%04x", MemAddress, MemDataIn);
            end
            if (Halt) begin
                $fdisplay(sim_log_file, "SIMLOG:: Processor halted\n");
                $fdisplay(sim_log_file, "SIMLOG:: sim_cycles %d\n", cycle_count);
                $fdisplay(sim_log_file, "SIMLOG:: inst_count %d\n", inst_count);
                $fdisplay(sim_log_file, "SIMLOG:: dcachehit_count %d\n", DCacheHit_count);
                $fdisplay(sim_log_file, "SIMLOG:: icachehit_count %d\n", ICacheHit_count);
                $fdisplay(sim_log_file, "SIMLOG:: dcachereq_count %d\n", DCacheReq_count);
                $fdisplay(sim_log_file, "SIMLOG:: icachereq_count %d\n", ICacheReq_count);


                $fclose(trace_file);
                $fclose(sim_log_file);
                #5;
                dumpMemory();
                $finish;
            end
        end
    end





    /* Assign internal signals to top level wires
    The internal module names and signal names will vary depending
    on your naming convention and your design */

    // Edit the example below. You must change the signal
    // names on the right hand side

    //   assign PC = DUT.fetch0.pcCurrent; //You won't need this because it's part of the main cpu interface

    //   assign Halt = DUT.memory0.halt; //You won't need this because it's part of the main cpu interface
    // Is processor halted (1 bit signal)


    assign Inst = DUT.if_inst;
    //Instruction fetched in the current cycle

    assign RegWrite = DUT.wb_RFwe;
    // Is register file being written to in this cycle, one bit signal (1 means yes, 0 means no)

    assign WriteRegister = DUT.wb_RFdst;
    // If above is true, this should hold the name of the register being written to. (4 bit signal)

    assign WriteData = DUT.wb_RFwriteData;
    // If above is true, this should hold the Data being written to the register. (16 bits)

    assign MemRead = (DUT.mem_inst[15:13] == 3'b100);
    // Is memory being read from, in this cycle. one bit signal (1 means yes, 0 means no)

    assign MemWrite = (DUT.mem_DataWe);
    // Is memory being written to, in this cycle (1 bit signal)

    assign MemAddress = DUT.mem_DataAddr;
    // If there's a memory access this cycle, this should hold the address to access memory with (for both reads and writes to memory, 16 bits)

    assign MemDataIn = DUT.mem_DataWriteData;
    // If there's a memory write in this cycle, this is the Data being written to memory (16 bits)

    assign MemDataOut = DUT.mem_DataReadData;
    // If there's a memory read in this cycle, this is the data being read out of memory (16 bits)

    assign ICacheReq = 1'b1;
    // Signal indicating a valid instruction read request to cache

    assign ICacheHit = ~DUT.i_miss & (~DUT.global_stall);
    // Signal indicating a valid instruction cache hit

    assign DCacheReq = (MemWrite | MemRead) & (~DUT.global_stall);
    // Signal indicating a valid instruction data read or write request to cache

    assign DCacheHit = ~DUT.d_miss & (~DUT.global_stall);
    // Signal indicating a valid data cache hit


    /* Add anything else you want here */


endmodule
