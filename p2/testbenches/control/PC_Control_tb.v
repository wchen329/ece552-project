module NeedBranch_tb();
    // testbench adapted from Zhenghao's code
    reg[2:0] C,F;
    wire need_branch;
    reg ans;
    reg [31:0] x;

    function should_branch;
        input [2:0] cond;
        input [2:0] flag;
        reg n,v,z;
        begin
            {z,v,n} = flag;

            should_branch = 0;
            if (cond == 0 && z == 0) should_branch = 1;
            if (cond == 1 && z == 1) should_branch = 1;
            if (cond == 2 && z == 0 && n == 0) should_branch = 1;
            if (cond == 3 && n==1) should_branch = 1;
            if (cond == 4 && ((z==1)||(z==0 && n==0))) should_branch = 1;
            if (cond == 5 && (n==1 || z==1)) should_branch = 1;
            if (cond == 6 && v==1) should_branch = 1;
            if (cond == 7) should_branch = 1;
        end
    endfunction

    NeedBranch DUT(.C(C), .F(F), .Branch(need_branch));

    initial begin
        for (x=0; x<32'h80; x=x+1) begin
            {C,F} = x[5:0];
            #1;
            ans = should_branch(C, F);
            if (ans != need_branch) $display("Test fail: C=%d, F=%d, got=%d, expected=%d", C, F, need_branch, ans);
        end
        $display("Test complete");
        $finish;
    end
endmodule

module NeedBranch_2nd_tb();
    // testbench adapted from Winor's code
    reg[2:0] C,F;
    wire need_branch;
    reg ans;
    reg [31:0] x;
    wire Zf, Vf, Nf;

    NeedBranch DUT(.C(C), .F(F), .Branch(need_branch));
    assign {Zf, Vf, Nf} = F[2:0];

    initial begin
        for (x=0; x<32'h80; x=x+1) begin
            {C,F} = x[5:0];
            #1;
            ans =
                C == 0 ?
                    Zf == 0 ? 1 : 0
                    :	// Not Equal
                C == 1 ?
                    Zf == 1 ? 1 : 0
                    :	// Equal
                C == 2 ?
                    Zf == 0 ? Nf == 0 ? 1 : 0 : 0
                    :	// Greater Than
                C == 3 ?
                    Nf == 1 ? 1 : 0
                    :	// Less Than
                C == 4 ?
                    Zf == 1 ? 1 : Zf == 0 ? Nf == 0 ? 1 : 0 : 0
                    :	// Greater Than or Equal
                C == 5 ?
                    Nf == 1 ? 1 : Zf == 1 ? 1 : 0
                    :	// Less Than or Equal
                C == 6 ?
                    Vf == 1 ? 1 : 0
                    :	// Overflow
                C == 7 ? 1 : 0;	// Unconditional
            if (ans != need_branch) $display("Test fail: C=%d, F=%d, got=%d, expected=%d", C, F, need_branch, ans);
        end
        $display("Test complete");
        $finish;
    end
endmodule

module PC_Control_tb();
    reg [3:0] opcode;
    reg[2:0] condition;
    reg[2:0] flag; // ZVN
    reg[8:0] offset;
    reg[15:0] br_reg;
    reg[15:0] pcIn;
    wire taken;
    wire[15:0] pcOut;
    PC_Control DUT(opcode, condition, flag, offset, br_reg, pcIn, taken, pcOut);

    reg signed [31:0] i,j;
    reg signed [15:0] signedPC;
    reg signed [9:0] signedOffset;
    reg [15:0] pcIn_plus2;
    reg ok;

    function should_branch;
        input [2:0] cond;
        input [2:0] flag;
        reg n,v,z;
        begin
            {z,v,n} = flag;

            should_branch = 0;
            if (cond == 0 && z == 0) should_branch = 1;
            if (cond == 1 && z == 1) should_branch = 1;
            if (cond == 2 && z == 0 && n == 0) should_branch = 1;
            if (cond == 3 && n==1) should_branch = 1;
            if (cond == 4 && ((z==1)||(z==0 && n==0))) should_branch = 1;
            if (cond == 5 && (n==1 || z==1)) should_branch = 1;
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
                if (pcOut != 36) $display("Branch test fail: cond:%d, flag:%d", condition, flag);
            end else begin
                if (pcOut != 52) $display("Not branch test fail: cond:%d, flag:%d", condition, flag);
            end
        end

        for (i=0;i<32'h800;i=i+1) begin
            {opcode,condition,flag,offset[8]} = i[10:0];
            for (j=0;j<50;j=j+1) begin
                {offset[7:0],br_reg,pcIn} = {$random,$random};
                ok = 1'b1;
                #2;
                pcIn_plus2 = pcIn+2;
                if (opcode == 4'b1100) begin
                    signedPC = pcIn;
                    signedOffset[9:0] = {offset, 1'b0};
                    signedPC = signedPC + signedOffset + $signed(2);

                    if (should_branch(condition, flag))
                        ok = ok & (pcOut == signedPC[15:0]);
                    else
                        ok = ok & (pcOut == pcIn_plus2);

                end else if (opcode == 4'b1101) begin
                    if (should_branch(condition, flag))
                        ok = ok & (pcOut == br_reg);
                    else
                        ok = ok & (pcOut == pcIn_plus2);
                end else begin
                    ok = ok & (pcOut == pcIn_plus2);
                end
                if (~ok) $display("Assert fail: opcode=%d, condition=%d, flag=%d, offset=%d, br_reg=%d, pcIn=%d, taken=%d, pcOut=%d, pcIn_plus2=%d, offset=%d, signedOffset=%d, signedPC=%d",
                                                opcode,    condition,    flag,    offset,    br_reg,    pcIn,    taken,    pcOut,    pcIn_plus2,    offset,    signedOffset,    signedPC);
            end
        end
        $display("Test complete");
        $finish;
    end
endmodule
