module PC_control_tb();
    reg[2:0] condition;
    reg[2:0] flag;
    reg[8:0] offset;
    reg[15:0] pcIn;
    wire[15:0] pcOut;
    PC_control DUT(condition, offset, flag, pcIn, pcOut);

    reg signed [31:0] i;

    function should_branch;
    input [2:0] cond;
    input [2:0] flag;
    reg n,v,z_;
    begin
        {z_,v,n} = flag;

        should_branch = 0;
        if (cond == 0 && z_ == 0) should_branch = 1;
        if (cond == 1 && z_ == 1) should_branch = 1;
        if (cond == 2 && z_ == 0 && n == 0) should_branch = 1;
        if (cond == 3 && n==1) should_branch = 1;
        if (cond == 4 && ((z_==1)||(z_==0 && n==0))) should_branch = 1;
        if (cond == 5 && (n==1 || z_==1)) should_branch = 1;
        if (cond == 6 && v==1) should_branch = 1;
        if (cond == 7) should_branch = 1;
    end
    endfunction

    initial begin
        pcIn = 50;
        offset = -8;

        for (i=0;i<64;i=i+1) begin
            {condition, flag} = i[5:0];
            #2;
            if (should_branch(condition, flag)) begin
                if (pcOut != 36) $display("Branch test fail: cond:%d, flag:%d, target: %d, branch_taken: %d", condition, flag, pcOut, DUT.branch_taken);
            end else begin
                if (pcOut != 52) $display("Not branch test fail: cond:%d, flag:%d, target: %d, branch_taken: %d", condition, flag, pcOut, DUT.branch_taken);
            end
        end
        $display("Test complete");
        $stop;
    end
endmodule