
module PC_control(C, I, F, PC_in, PC_out);

input [2:0] C; //3-bit condition
input [8:0] I; //9-bit offset
input [2:0] F; //3-bit flag
input [15:0] PC_in;
output [15:0] PC_out;
wire [15:0] PC1, PC2, PC3;
wire Branch;

CLAdder16 ADD1(.Sum(PC1), .A(PC_in), .B(16'h0002)); //The PC_out is PC1 if branch is not taken
assign PC2 = {{6{I[8]}}, (I << 1'b1)};
CLAdder16 ADD2(.Sum(PC3), .A(PC1), .B(PC2)); //if branch is taken, PC_out is PC3

Check_Branch CHECK(.C(C), .F(F), .Branch(Branch));

assign PC_out = (Branch) ? PC3 : PC1;

endmodule
