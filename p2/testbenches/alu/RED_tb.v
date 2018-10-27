module RED_tb();
    reg[15:0] A, B;
    wire signed[15:0] Reduction;

    reg[63:0] i;
    reg signed [7:0] E,F,G,H;
    reg signed [15:0] Ans;

    RED DUT(A, B, Reduction);
    initial begin
        {A,B} = 32'hD5AA0000;
        #1;
        $display("Expected: -129, Got: %d", Reduction);
        {A,B} = 32'h80808080;
        #1;
        $display("Expected: -512, Got: %d", Reduction);
        //$finish;

        for (i=0; i <= 64'h2FFFF; i=i+1) begin
            {A, B} = $random;
            #1;
            {E,F,G,H} = {A,B};
            Ans = E+F+G+H;
            if (Reduction != Ans) $display("Unexpected output: A:%d, B:%d, Ans:%d, Reduction:%d", A, B, Ans, Reduction);
        end
        $display("Test complete");
        $finish;
    end
endmodule