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
        $fdisplay(sim_log_file, "SIMLOG:: Cycle             PC:          I:          R:[WE] [WR] [DATA] M: [R][W]     [Addr]     [In]     [OutFromMem]");
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

            $fdisplay(sim_log_file, "SIMLOG:: Cycle %d PC: %8x I: %8x R: %d %3d %8x M: %d %d %8x %8x %8x",
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
                                    MemDataOut);
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
