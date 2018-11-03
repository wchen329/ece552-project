module RegisterFile_simple_tb();
    reg clk;
    reg rst;
    reg [3:0] SrcReg1, SrcReg2, DstReg;
    reg WriteReg;
    reg [15:0] DstData;
    wire [15:0] SrcData1, SrcData2;
    RegisterFile_simple DUT(clk, rst, SrcReg1, SrcReg2, DstReg, WriteReg, DstData, SrcData1, SrcData2);

    reg signed [31:0] i;
    reg [31:0] tmp;

    task assert_content;
        input[3:0] reg_addr;
        input[16:0] reg_content;
        input[16:0] expected_content;
        input errorId;

        begin
            if (reg_addr == 0) begin
                if (reg_content != 0)
                    $display("Error%0d: R[%0d]=%0d, expected 0", errorId, reg_addr, reg_content);
            end else begin
                if (reg_content != expected_content)
                    $display("Error%0d: R[%0d]=%0d, expected %0d", errorId, reg_addr, reg_content, expected_content);
            end
        end
    endtask

always #5 clk = ~clk;
initial begin
    clk=0; // positive edge occurs at 5,15,25...
    #0; // test reset
    rst = 1;
    WriteReg = 0;
    #10; // pass first pos edge, RF reset.

    // read / ~we test
    // Since reads are just combinational logic
    // we don't really care clock edges here
    rst = 0;
    DstData = 16'hffff;
    for (i=0;i<16;i=i+1) begin
        SrcReg1 = i[3:0]; // setup input at the beginning
        SrcReg2 = i[3:0];
        DstReg = (i+1);
        #2; // wait 2 ns so the output is changed (we are before the posedges)
        assert_content(SrcReg1, SrcData1, 0, 1);
        assert_content(SrcReg2, SrcData2, 0, 1);
        //if (SrcData1 != 16'h0000) $display("Error1: expect 0 at %d", $time);
        //if (SrcData2 != 16'h0000) $display("Error1: expect 0 at %d", $time);
        #5; // wait another 5 ns so we go across the posedge
        assert_content(SrcReg1, SrcData1, 0, 2);
        assert_content(SrcReg2, SrcData2, 0, 2);
        //if (SrcData1 != 16'h0000) $display("Error2: expect 0 at %d", $time); // check again
        //if (SrcData2 != 16'h0000) $display("Error2: expect 0 at %d", $time);
        #3;
    end

    // Test bypass logic, but without writing
    for (i=0;i<16;i=i+1) begin
        // Setup input data at the beginning, WE=0
        SrcReg1 = i[3:0];
        SrcReg2 = i[3:0];
        DstReg = i[3:0];
        DstData = {12'b10000, i[3:0]};
        WriteReg = 0;
        #1; // wait 1 ns, now the output should still be zero
        assert_content(SrcReg1, SrcData1, 0, 3);
        assert_content(SrcReg2, SrcData2, 0, 3);
        //if (SrcData1 != 16'h0000) $display("Error3: expect 0 at %d", $time);
        //if (SrcData2 != 16'h0000) $display("Error3: expect 0 at %d", $time);

        WriteReg = 1; // change WE=1
        #1; // the input should now be forworded to output
        assert_content(SrcReg1, SrcData1, i+256, 4);
        assert_content(SrcReg2, SrcData2, i+256, 4);
        //if (SrcData1 != i+256) $display("Error4: expect %d at %d", i+256, $time);
        //if (SrcData2 != i+256) $display("Error4: expect %d at %d", i+256, $time);

        tmp=i+1;
        DstReg = tmp[3:0]; // change dst reg
        #1; // now the output should back to zero
        assert_content(SrcReg1, SrcData1, 0, 5);
        assert_content(SrcReg2, SrcData2, 0, 5);
        //if (SrcData1 != 16'h0000) $display("Error5: expect 0 at %d", $time);
        //if (SrcData2 != 16'h0000) $display("Error5: expect 0 at %d", $time);

        WriteReg = 0;
        DstReg = i[3:0]; // revert input
        #5; // now go across the posedge, read should still be zero
        assert_content(SrcReg1, SrcData1, 0, 6);
        assert_content(SrcReg2, SrcData2, 0, 6);
        //if (SrcData1 != 16'h0000) $display("Error6: expect 0 at %d", $time);
        //if (SrcData2 != 16'h0000) $display("Error6: expect 0 at %d", $time);

        #2;
    end

    // test write then read
    for (i=0;i<16;i=i+1) begin
        // setup signal for read
        WriteReg = 0;
        DstData = 16'hAAAA;
        SrcReg1 = i[3:0];
        SrcReg2 = i[3:0];
        DstReg = i[3:0];
        WriteReg = 0;
        #1; // verify that old data is zero
        assert_content(SrcReg1, SrcData1, 0, 7);
        assert_content(SrcReg2, SrcData2, 0, 7);
        //if (SrcData1 != 16'h0000) $display("Error7: expect 0 at %d", $time);
        //if (SrcData2 != 16'h0000) $display("Error7: expect 0 at %d", $time);

        WriteReg=1;
        #1; // verify that forwarding works
        assert_content(SrcReg1, SrcData1, 16'hAAAA, 8);
        assert_content(SrcReg2, SrcData2, 16'hAAAA, 8);
        //if (SrcData1 != 16'hAAAA) $display("Error8: expect AAAA at %d", $time);
        //if (SrcData2 != 16'hAAAA) $display("Error8: expect AAAA at %d", $time);

        #4; // let it write, pass the posedge
        assert_content(SrcReg1, SrcData1, 16'hAAAA, 9);
        assert_content(SrcReg2, SrcData2, 16'hAAAA, 9);
        //if (SrcData1 != 16'hAAAA) $display("Error9: expect AAAA at %d", $time);
        //if (SrcData2 != 16'hAAAA) $display("Error9: expect AAAA at %d", $time);

        WriteReg = 0;
        #1; // disable WE and see if value stored
        assert_content(SrcReg1, SrcData1, 16'hAAAA, 10);
        assert_content(SrcReg2, SrcData2, 16'hAAAA, 10);
        //if (SrcData1 != 16'hAAAA) $display("Error10: expect AAAA at %d", $time);
        //if (SrcData2 != 16'hAAAA) $display("Error10: expect AAAA at %d", $time);

        WriteReg = 1;
        DstData = 16'h5555;
        #1; // change the input and check if forwarding still works
        assert_content(SrcReg1, SrcData1, 16'h5555, 11);
        assert_content(SrcReg2, SrcData2, 16'h5555, 11);
        //if (SrcData1 != 16'h5555) $display("Error11: expect 5555 at %d", $time);
        //if (SrcData2 != 16'h5555) $display("Error11: expect 5555 at %d", $time);

        #2;
    end
    $display("Test complete");
    $finish;
end
endmodule
