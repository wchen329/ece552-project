module Shifter_tb();
    reg[15:0] IN;
    reg[3:0] offset;
    reg[2:0] opcode;
    wire[15:0] OUT;

    reg[63:0] i;
    reg[31:0] o;
    reg[15:0] ANS;
    reg signed[15:0] tmp;

    Shifter_3_1 DUT(OUT, IN, offset, opcode);
    initial begin

        // small test for ROR
        opcode = 3'b010;
        offset = 4'b1111;
        IN = 16'h0001;
        #1;
        $display("expected: 2, got: %d", OUT);
        //$finish;


        // SLL Testing
        opcode = 3'b000;
        for (o = 0; o < 16; o=o+1) begin
            offset = o[3:0];
            for (i=0;i<=64'hFFF;i=i+1) begin
                IN = $random;
                #1;
                ANS = IN << offset;
                if (OUT != ANS) $display("SLL Test fail. IN:%d, offset:%d, ANS:%d, OUT:%d", IN, offset, ANS, OUT);
            end
        end
        $display("SLL tests complete");

        // SRA Testing
        opcode = 3'b001;
        for (o = 0; o < 16; o=o+1) begin
            offset = o[3:0];
            for (i=0;i<=64'hFFF;i=i+1) begin
                IN = $random;
                #1;
                tmp = IN;
                ANS = tmp >>> offset;
                if (OUT != ANS) $display("SRA Test fail. IN:%d, offset:%d, ANS:%d, OUT:%d", IN, offset, ANS, OUT);
            end
        end
        $display("SRA tests complete");

        // ROR Testing
        opcode = 3'b010;
        for (o = 0; o < 16; o=o+1) begin
            offset = o[3:0];
            for (i=0;i<=64'hFFF;i=i+1) begin
                IN = $random;
                #1;
                ANS = {IN, IN} >> offset;
                if (OUT != ANS) $display("ROR Test fail. IN:%d, offset:%d, ANS:%d, OUT:%d", IN, offset, ANS, OUT);
            end
        end
        $display("ROR tests complete");

        $finish;
    end
endmodule