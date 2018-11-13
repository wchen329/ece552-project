module ALU_add_tb();
    reg[15:0] A,B;
    reg[3:0] op;
    wire[15:0] out;
    wire z,v,n;

    reg signed[31:0] A_,B_,S_,i;

    ALU DUT(A,B,op,out,{z,v,n});

    task verify;
    begin
        S_ = A_+B_;
        if (S_ > 32767) begin
            if ({z,v,n} != 3'b010) $display("line%d:flag error A=%0d B=%0d ZVN=%3b", `__LINE__, A_, B_, {z,v,n});
            if (out != 16'h7FFF) $display("line%d:output error A=%0d B=%0d out=%0d", `__LINE__, A_, B_, out);
        end else if (S_ < -32768) begin
            if ({z,v,n} != 3'b011) $display("line%d:flag error A=%0d B=%0d ZVN=%3b", `__LINE__, A_, B_, {z,v,n});
            if (out != 16'h8000) $display("line%d:output error A=%0d B=%0d out=%0d", `__LINE__, A_, B_, out);
        end else begin
            if (v)           $display("line%d:flag error A=%0d B=%0d ZVN=%3b", `__LINE__, A_, B_, {z,v,n});
            if (S_==0 && ~z) $display("line%d:flag error A=%0d B=%0d ZVN=%3b", `__LINE__, A_, B_, {z,v,n});
            if (S_>=0 && n)  $display("line%d:flag error A=%0d B=%0d ZVN=%3b", `__LINE__, A_, B_, {z,v,n});
            if (out!=S_[15:0]) $display("line%d:output error A=%0d B=%0d out=%0d", `__LINE__, A_, B_, out);
        end
    end
    endtask

    initial begin
        op = 4'b0000;
        for (A_=-32768;A_<-32752;A_=A_+1) begin // edge case testing
            for (B_=-32768;B_<-32752;B_=B_+1) begin
                A=A_[15:0];
                B=B_[15:0];
                #1;
                verify();
            end
            for (B_=-32;B_<32;B_=B_+1) begin
                A=A_[15:0];
                B=B_[15:0];
                #1;
                verify();
            end
            for (B_=32752;B_<32768;B_=B_+1) begin
                A=A_[15:0];
                B=B_[15:0];
                #1;
                verify();
            end
        end
        for (A_=-32;A_<32;A_=A_+1) begin // edge case testing
            for (B_=-32768;B_<-32752;B_=B_+1) begin
                A=A_[15:0];
                B=B_[15:0];
                #1;
                verify();
            end
            for (B_=-32;B_<32;B_=B_+1) begin
                A=A_[15:0];
                B=B_[15:0];
                #1;
                verify();
            end
            for (B_=32752;B_<32768;B_=B_+1) begin
                A=A_[15:0];
                B=B_[15:0];
                #1;
                verify();
            end
        end
        for (A_=32752;A_<32768;A_=A_+1) begin // edge case testing
            for (B_=-32768;B_<-32752;B_=B_+1) begin
                A=A_[15:0];
                B=B_[15:0];
                #1;
                verify();
            end
            for (B_=-32;B_<32;B_=B_+1) begin
                A=A_[15:0];
                B=B_[15:0];
                #1;
                verify();
            end
            for (B_=32752;B_<32768;B_=B_+1) begin
                A=A_[15:0];
                B=B_[15:0];
                #1;
                verify();
            end
        end

        for (i=0;i<4096;i=i+1) begin
            {A_[15:0],B_[15:0]} = $random;
            A_[31:16] = {16{A_[15]}};
            B_[31:16] = {16{B_[15]}};
            A=A_[15:0];
            B=B_[15:0];
            #1;
            verify();
        end

        $display("Test complete");
        $finish;
    end
endmodule

module ALU_sub_tb();
    reg[15:0] A,B;
    reg[3:0] op;
    wire[15:0] out;
    wire z,v,n;

    reg signed[31:0] A_,B_,S_,i;

    ALU DUT(A,B,op,out,{z,v,n});

    task verify;
    begin
        S_ = A_-B_;
        if (S_ > 32767) begin
            if ({z,v,n} != 3'b010) $display("line%d:flag error A=%0d B=%0d ZVN=%3b", `__LINE__, A_, B_, {z,v,n});
            if (out != 16'h7FFF) $display("line%d:output error A=%0d B=%0d out=%0d", `__LINE__, A_, B_, out);
        end else if (S_ < -32768) begin
            if ({z,v,n} != 3'b011) $display("line%d:flag error A=%0d B=%0d ZVN=%3b", `__LINE__, A_, B_, {z,v,n});
            if (out != 16'h8000) $display("line%d:output error A=%0d B=%0d out=%0d", `__LINE__, A_, B_, out);
        end else begin
            if (v)           $display("line%d:flag error A=%0d B=%0d ZVN=%3b", `__LINE__, A_, B_, {z,v,n});
            if (S_==0 && ~z) $display("line%d:flag error A=%0d B=%0d ZVN=%3b", `__LINE__, A_, B_, {z,v,n});
            if (S_>=0 && n)  $display("line%d:flag error A=%0d B=%0d ZVN=%3b", `__LINE__, A_, B_, {z,v,n});
            if (out!=S_[15:0]) $display("line%d:output error A=%0d B=%0d out=%0d", `__LINE__, A_, B_, out);
        end
    end
    endtask

    initial begin
        op = 4'b0001;
        for (A_=-32768;A_<-32752;A_=A_+1) begin // edge case testing
            for (B_=-32768;B_<-32752;B_=B_+1) begin
                A=A_[15:0];
                B=B_[15:0];
                #1;
                verify();
            end
            for (B_=-32;B_<32;B_=B_+1) begin
                A=A_[15:0];
                B=B_[15:0];
                #1;
                verify();
            end
            for (B_=32752;B_<32768;B_=B_+1) begin
                A=A_[15:0];
                B=B_[15:0];
                #1;
                verify();
            end
        end
        for (A_=-32;A_<32;A_=A_+1) begin // edge case testing
            for (B_=-32768;B_<-32752;B_=B_+1) begin
                A=A_[15:0];
                B=B_[15:0];
                #1;
                verify();
            end
            for (B_=-32;B_<32;B_=B_+1) begin
                A=A_[15:0];
                B=B_[15:0];
                #1;
                verify();
            end
            for (B_=32752;B_<32768;B_=B_+1) begin
                A=A_[15:0];
                B=B_[15:0];
                #1;
                verify();
            end
        end
        for (A_=32752;A_<32768;A_=A_+1) begin // edge case testing
            for (B_=-32768;B_<-32752;B_=B_+1) begin
                A=A_[15:0];
                B=B_[15:0];
                #1;
                verify();
            end
            for (B_=-32;B_<32;B_=B_+1) begin
                A=A_[15:0];
                B=B_[15:0];
                #1;
                verify();
            end
            for (B_=32752;B_<32768;B_=B_+1) begin
                A=A_[15:0];
                B=B_[15:0];
                #1;
                verify();
            end
        end

        for (i=0;i<4096;i=i+1) begin
            {A_[15:0],B_[15:0]} = $random;
            A_[31:16] = {16{A_[15]}};
            B_[31:16] = {16{B_[15]}};
            A=A_[15:0];
            B=B_[15:0];
            #1;
            verify();
        end

        $display("Test complete");
        $finish;
    end
endmodule

module ALU_xor_tb();
    reg[15:0] A,B,S;
    reg[3:0] op;
    wire[15:0] out;
    wire z,v,n;

    reg signed[31:0] A_,B_,S_,i;

    ALU DUT(A,B,op,out,{z,v,n});

    task verify;
    begin
        S=A^B;
        if (out != S)  $display("line%d:output error A=%0d B=%0d S=%0d out=%0d ZVN=%3b", `__LINE__, A, B, S, out, {z,v,n});
        if (z != (S==0)) $display("line%d:flag error A=%0d B=%0d S=%0d out=%0d ZVN=%3b", `__LINE__, A, B, S, out, {z,v,n});
    end
    endtask

    initial begin
        op = 4'b0010;

        for (i=0;i<4096;i=i+1) begin
            {A[4:0],B[4:0]} = i[9:0];
            {A[15:5],B[15:5]} = 22'b0;
            #1;
            verify();

            {A,B} = $random;
            #1;
            verify();
        end

        $display("Test complete");
        $finish;
    end
endmodule

module ALU_red_tb();
    reg[15:0] A,B,S;
    reg[3:0] op;
    wire[15:0] out;
    wire z,v,n;

    reg signed[31:0] A_,B_,S_,i;

    ALU DUT(A,B,op,out,{z,v,n});

    task verify;
    reg signed [7:0] E,F,G,H;
    begin
        {E,F,G,H}={A,B};
        S_ = E+F+G+H;
        if (out != S_[15:0]) $display("line%d:output error A=%0d B=%0d S=%0d out=%0d ZVN=%3b", `__LINE__, A, B, S_, out, {z,v,n});
        // if (z != (S_==0)) $display("line%d:flag error A=%0d B=%0d S=%0d out=%0d ZVN=%3b", `__LINE__, A, B, S_, out, {z,v,n});
    end
    endtask

    initial begin
        op = 4'b0011;

        for (i=0;i<4096;i=i+1) begin
            {A,B} = $random;
            #1;
            verify();
        end

        $display("Test complete");
        $finish;
    end
endmodule

module ALU_sll_tb();
    reg[15:0] A,B,S;
    reg[3:0] op;
    wire[15:0] out;
    wire z,v,n;

    reg signed[31:0] A_,B_,S_,i;

    ALU DUT(A,B,op,out,{z,v,n});

    task verify;
    reg signed [7:0] E,F,G,H;
    begin
        S=A<<B[3:0];
        if (out != S[15:0]) $display("line%d:output error A=%0d B=%0d S=%0d out=%0d ZVN=%3b", `__LINE__, A, B[3:0], S, out, {z,v,n});
        if (z != (S==0)) $display("line%d:flag error A=%0d B=%0d S=%0d out=%0d ZVN=%3b", `__LINE__, A, B[3:0], S, out, {z,v,n});
    end
    endtask

    initial begin
        op = 4'b0100;

        for (i=0;i<4096;i=i+1) begin
            {A,B} = $random;
            #1;
            verify();
        end

        $display("Test complete");
        $finish;
    end
endmodule

module ALU_sra_tb();
    reg[15:0] A,B,S;
    reg[3:0] op;
    wire[15:0] out;
    wire z,v,n;

    reg signed[31:0] A_,B_,S_,i;

    ALU DUT(A,B,op,out,{z,v,n});

    task verify;
    reg signed [7:0] E,F,G,H;
    begin
        A_={ {16{A[15]}}, A };
        S_=A_>>>B[3:0];
        if (out != S_[15:0]) $display("line%d:output error A=%0d B=%0d S=%0d out=%0d ZVN=%3b", `__LINE__, A_, B[3:0], S_, out, {z,v,n});
        if (z != (S==0)) $display("line%d:flag error A=%0d B=%0d S=%0d out=%0d ZVN=%3b", `__LINE__, A_, B[3:0], S_, out, {z,v,n});
    end
    endtask

    initial begin
        op = 4'b0101;

        for (i=0;i<4096;i=i+1) begin
            {A,B} = $random;
            #1;
            verify();
        end

        $display("Test complete");
        $finish;
    end
endmodule

module ALU_ror_tb();
    reg[15:0] A,B,S;
    reg[3:0] op;
    wire[15:0] out;
    wire z,v,n;

    reg signed[31:0] A_,B_,S_,i;

    ALU DUT(A,B,op,out,{z,v,n});

    task verify;
    reg signed [7:0] E,F,G,H;
    begin
        S={A,A}>>B[3:0];
        if (out != S[15:0]) $display("line%d:output error A=%0d B=%0d S=%0d out=%0d ZVN=%3b", `__LINE__, A, B[3:0], S, out, {z,v,n});
        if (z != (S==0)) $display("line%d:flag error A=%0d B=%0d S=%0d out=%0d ZVN=%3b", `__LINE__, A, B[3:0], S, out, {z,v,n});
    end
    endtask

    initial begin
        op = 4'b0110;

        for (i=0;i<4096;i=i+1) begin
            {A,B} = $random;
            #1;
            verify();
        end

        $display("Test complete");
        $finish;
    end
endmodule

module ALU_paddsb_tb();
    reg[15:0] A,B,S;
    reg[3:0] op;
    wire[15:0] out;
    wire z,v,n;

    reg signed[31:0] A_,B_,S_,i;

    ALU DUT(A,B,op,out,{z,v,n});

    function[3:0] add;
    input signed[3:0] A,B;
    reg signed[7:0] A_,B_,S_;
    begin
        A_=A;
        B_=B;
        S_=A_+B_;
        if (S_>7)  add=4'b0111; else
        if (S_<-8) add=4'b1000; else
                   add=S_[3:0];
    end
    endfunction


    task verify;
    reg signed [7:0] E,F,G,H;
    begin
        S[15:12] = add(A[15:12],B[15:12]);
        S[11:8] = add(A[11:8],B[11:8]);
        S[7:4] = add(A[7:4],B[7:4]);
        S[3:0] = add(A[3:0],B[3:0]);
        if (out != S[15:0]) $display("line%d:output error A=%0d B=%0d S=%0d out=%0d ZVN=%3b", `__LINE__, A, B, S, out, {z,v,n});
    end
    endtask

    initial begin
        op = 4'b0111;

        for (i=0;i<4096;i=i+1) begin
            {A,B} = 32'b0;
            {A[3:0],B[3:0]} = i[7:0];
            #1;
            verify();

            {A,B} = $random;
            #1;
            verify();
        end

        $display("Test complete");
        $finish;
    end
endmodule

module ALU_llb_tb();
    reg[15:0] A,B,S;
    reg[3:0] op;
    wire[15:0] out;
    wire z,v,n;

    reg signed[31:0] A_,B_,S_,i;

    ALU DUT(A,B,op,out,{z,v,n});

    task verify;
    reg signed [7:0] E,F,G,H;
    begin
        if ({A[15:8],B[7:0]} != out) $display("line%d:output error A=%0d B=%0d S=%0d out=%0d ZVN=%3b", `__LINE__, A, B, {A[15:8],B[7:0]}, out, {z,v,n});
    end
    endtask

    initial begin
        op = 4'b1010;

        for (i=0;i<4096;i=i+1) begin
            {A,B} = $random;
            #1;
            verify();
        end

        $display("Test complete");
        $finish;
    end
endmodule

module ALU_lhb_tb();
    reg[15:0] A,B,S;
    reg[3:0] op;
    wire[15:0] out;
    wire z,v,n;

    reg signed[31:0] A_,B_,S_,i;

    ALU DUT(A,B,op,out,{z,v,n});

    task verify;
    reg signed [7:0] E,F,G,H;
    begin
        if ({B[7:0],A[7:0]} != out) $display("line%d:output error A=%0d B=%0d S=%0d out=%0d ZVN=%3b", `__LINE__, A, B, {B[7:0],A[7:0]}, out, {z,v,n});
    end
    endtask

    initial begin
        op = 4'b1011;

        for (i=0;i<4096;i=i+1) begin
            {A,B} = $random;
            #1;
            verify();
        end

        $display("Test complete");
        $finish;
    end
endmodule

module ALU_memaddr_tb();
    reg[15:0] A,B,S;
    reg[3:0] op;
    wire[15:0] out;
    wire z,v,n;

    reg signed[31:0] A_,B_,S_,i;

    ALU DUT(A,B,op,out,{z,v,n});

    task verify;
    reg signed [4:0] O;
    reg signed [15:0] E;
    begin
        O = B[4:0] << 1;
        E = A & 16'hFFFE;
        E = E + O;
        if (E[15:0] != out) $display("line%d:output error A=%0d B=%0d S=%0d out=%0d ZVN=%3b", `__LINE__, A, B[3:0], E[15:0], out, {z,v,n});
    end
    endtask

    initial begin
        op = 4'b1000;

        for (i=0;i<4096;i=i+1) begin
            {A,B} = $random;
            #1;
            verify();
        end

        op = 4'b1001;

        for (i=0;i<4096;i=i+1) begin
            {A,B} = $random;
            #1;
            verify();
        end

        $display("Test complete");
        $finish;
    end
endmodule