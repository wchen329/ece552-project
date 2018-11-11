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
        if (z != (S_==0)) $display("line%d:flag error A=%0d B=%0d S=%0d out=%0d ZVN=%3b", `__LINE__, A, B, S_, out, {z,v,n});
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