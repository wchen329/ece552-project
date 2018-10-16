module SimpleCLA_tb();
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