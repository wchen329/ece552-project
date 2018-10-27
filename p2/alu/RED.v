module RED(A, B, Reduction);
    input [15:0] A, B;
    output [15:0] Reduction;

    wire [11:0] sumA, sumB;
    wire carryA, carryB;
    wire [11:0] sumAB;

    CLAdder8E  adder0(.A(A[15:8]), .B(B[15:8]), .Cin(1'b0), .Sum(sumA[7:0]), .Cout(carryA), .overflow(), .zero(), .overflowDirection());
    CLAdder8E  adder1(.A(A[7:0]), .B(B[7:0]), .Cin(1'b0), .Sum(sumB[7:0]), .Cout(carryB), .overflow(), .zero(), .overflowDirection());

    assign sumA[11:8] = ((A[15] == 1'b0) & (B[15] == 1'b0)) ? {3'b000, carryA} :
                        ((A[15] == 1'b1) & (B[15] == 1'b1)) ? 4'b1111 : {4{~carryA}};
    assign sumB[11:8] = ((A[7] == 1'b0) & (B[7] == 1'b0)) ? {3'b000, carryB} :
                        ((A[7] == 1'b1) & (B[7] == 1'b1)) ? 4'b1111 : {4{~carryB}};

    CLAdder12E adder2(.A(sumA), .B({sumB}), .Cin(1'b0), .Sum(sumAB), .Cout(), .overflow(), .zero(), .overflowDirection());

    assign Reduction = { {4{sumAB[11]}}, sumAB };
endmodule
