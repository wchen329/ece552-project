module CLAdder16_tb();
    reg[15:0] A, B, Ans;
    wire[15:0] Sum;

    reg[63:0] i;

    CLAdder16 DUT(A, B, Sum);
    initial begin
        for (i=0; i <= 64'hFFFFF; i=i+1) begin
            {A, B} = $random;
            #1;
            Ans = A+B;
            if (Sum != Ans) $display("Unexpected output: A:%d, B:%d, Ans:%d, Sum:%d", A, B, Ans, Sum);
        end
        $display("Test complete");
        $finish;
    end
endmodule

module CLAdder8E_tb();
    reg[7:0] A, B;
    wire[7:0] Sum;
    wire Cout, overflow, zero, direction;

    reg [7:0] Ans;

    reg[15:0] A3, B3, Ans3;

    reg signed[7:0] A2, B2;
    reg signed[15:0] Ans2;
    reg signed[31:0] i;

    CLAdder8E DUT(A, B, 1'b0, Sum, Cout, overflow, zero, direction);

    initial begin
        for (i=0; i<32'h20000; i=i+1) begin
            {A,B} = i[15:0];
            {A2, B2} = {A,B};
            A3 = A;
            B3 = B;
            #1;
            Ans = A+B;
            Ans2 = A2+B2;
            Ans3 = A3+B3;

            if (Ans != Sum) $display("Sum error");
            if (Cout != Ans3[8]) $display("Cout error");
            if (overflow != ((Ans2 > 127) | (Ans2 < -128))) $display("overflow error");
            if (zero != (Ans == 0)) $display("zero error");
            if (overflow)
                if (direction == B[7]) $display("direction error");
        end
        $display("Test complete");
        $finish;
    end
endmodule