module CLABit(a, b, cin, p, g, s);
    input a, b, cin;
    output p, g, s;

    assign p = a | b;
    assign g = a & b;
    assign s = a^b^cin;
endmodule

module CLABlock4(cin, Pin, Gin, Cout, Pout, Gout);
    input cin;
    input[3:0] Pin, Gin;
    output[3:0] Cout;
    output Pout, Gout;

    assign Cout = {
        Gin[2] | (Pin[2] & Gin[1]) | (Pin[2] & Pin[1] & Gin[0]) | (Pin[2] & Pin[1] & Pin[0] & cin) ,
        Gin[1] | (Pin[1] & Gin[0]) | (Pin[1] & Pin[0] & cin),
        Gin[0] | (Pin[0] & cin),
        cin
    };

    assign Pout = Pin[3] & Pin[2] & Pin[1] & Pin[0];
    assign Gout = Gin[3] | (Pin[3] & Gin[2]) | (Pin[3] & Pin[2] & Gin[1]) | (Pin[3] & Pin[2] & Pin[1] & Gin[0]);
endmodule

module CLABlock16(cin, Pin, Gin, Cout, Pout, Gout);
    input cin;
    input[15:0] Pin, Gin;
    output[15:0] Cout;
    output Pout, Gout;

    wire[3:0] LowHighP, LowHighG, LowHighC;

    CLABlock4 low0(.cin(LowHighC[0]), .Pin(Pin[3:0]),   .Gin(Gin[3:0]),   .Cout(Cout[3:0]),   .Pout(LowHighP[0]), .Gout(LowHighG[0]));
    CLABlock4 low1(.cin(LowHighC[1]), .Pin(Pin[7:4]),   .Gin(Gin[7:4]),   .Cout(Cout[7:4]),   .Pout(LowHighP[1]), .Gout(LowHighG[1]));
    CLABlock4 low2(.cin(LowHighC[2]), .Pin(Pin[11:8]),  .Gin(Gin[11:8]),  .Cout(Cout[11:8]),  .Pout(LowHighP[2]), .Gout(LowHighG[2]));
    CLABlock4 low3(.cin(LowHighC[3]), .Pin(Pin[15:12]), .Gin(Gin[15:12]), .Cout(Cout[15:12]), .Pout(LowHighP[3]), .Gout(LowHighG[3]));
    CLABlock4 high(.cin(cin), .Pin(LowHighP), .Gin(LowHighG), .Cout(LowHighC), .Pout(Pout), .Gout(Gout));
endmodule

module CLAdder16(A, B, Sum);
    input[15:0] A, B;
    output[15:0] Sum;

    wire[15:0] P, G, C;
    CLABlock16 cla_block(.cin(1'b0), .Pin(P), .Gin(G), .Cout(C), .Pout(), .Gout());

    CLABit bit0(.a(A[0]), .b(B[0]), .cin(C[0]), .p(P[0]), .g(G[0]), .s(Sum[0]));
    CLABit bit1(.a(A[1]), .b(B[1]), .cin(C[1]), .p(P[1]), .g(G[1]), .s(Sum[1]));
    CLABit bit2(.a(A[2]), .b(B[2]), .cin(C[2]), .p(P[2]), .g(G[2]), .s(Sum[2]));
    CLABit bit3(.a(A[3]), .b(B[3]), .cin(C[3]), .p(P[3]), .g(G[3]), .s(Sum[3]));
    CLABit bit4(.a(A[4]), .b(B[4]), .cin(C[4]), .p(P[4]), .g(G[4]), .s(Sum[4]));
    CLABit bit5(.a(A[5]), .b(B[5]), .cin(C[5]), .p(P[5]), .g(G[5]), .s(Sum[5]));
    CLABit bit6(.a(A[6]), .b(B[6]), .cin(C[6]), .p(P[6]), .g(G[6]), .s(Sum[6]));
    CLABit bit7(.a(A[7]), .b(B[7]), .cin(C[7]), .p(P[7]), .g(G[7]), .s(Sum[7]));
    CLABit bit8(.a(A[8]), .b(B[8]), .cin(C[8]), .p(P[8]), .g(G[8]), .s(Sum[8]));
    CLABit bit9(.a(A[9]), .b(B[9]), .cin(C[9]), .p(P[9]), .g(G[9]), .s(Sum[9]));
    CLABit bit10(.a(A[10]), .b(B[10]), .cin(C[10]), .p(P[10]), .g(G[10]), .s(Sum[10]));
    CLABit bit11(.a(A[11]), .b(B[11]), .cin(C[11]), .p(P[11]), .g(G[11]), .s(Sum[11]));
    CLABit bit12(.a(A[12]), .b(B[12]), .cin(C[12]), .p(P[12]), .g(G[12]), .s(Sum[12]));
    CLABit bit13(.a(A[13]), .b(B[13]), .cin(C[13]), .p(P[13]), .g(G[13]), .s(Sum[13]));
    CLABit bit14(.a(A[14]), .b(B[14]), .cin(C[14]), .p(P[14]), .g(G[14]), .s(Sum[14]));
    CLABit bit15(.a(A[15]), .b(B[15]), .cin(C[15]), .p(P[15]), .g(G[15]), .s(Sum[15]));
endmodule
