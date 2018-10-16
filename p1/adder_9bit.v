//Add 2 9-bits input and provide a 10-bit output

module adder_9bit(Sum, A,B);
input [8:0] A, B; 
output [9:0] Sum; //9-bit output 
wire w1, w2, w3, w4, w5, w6, w7, w8; 

//instantiate 1-bit adders
full_adder_1_bit FA0(.a(A[0]), .b(B[0]), .cin(0), .sum(Sum[0]), .cout(w1));
full_adder_1_bit FA1(.a(A[1]), .b(B[1]), .cin(w1), .sum(Sum[1]), .cout(w2)); 
full_adder_1_bit FA2(.a(A[2]), .b(B[2]), .cin(w2), .sum(Sum[2]), .cout(w3)); 
full_adder_1_bit FA3(.a(A[3]), .b(B[3]), .cin(w3), .sum(Sum[3]), .cout(w4)); 
full_adder_1_bit FA4(.a(A[4]), .b(B[4]), .cin(w4), .sum(Sum[4]), .cout(w5)); 
full_adder_1_bit FA5(.a(A[5]), .b(B[5]), .cin(w5), .sum(Sum[5]), .cout(w6)); 
full_adder_1_bit FA6(.a(A[6]), .b(B[6]), .cin(w6), .sum(Sum[6]), .cout(w7)); 
full_adder_1_bit FA7(.a(A[7]), .b(B[7]), .cin(w7), .sum(Sum[7]), .cout(w8));
full_adder_1_bit FA8(.a(A[8]), .b(B[8]), .cin(w8), .sum(Sum[8]), .cout(Sum[9]));  

endmodule

