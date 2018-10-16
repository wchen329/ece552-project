module Check_Branch(C, F, Branch);

input [2:0] C; //3-bit condition
input [2:0] F; //3-bit flag
output Branch; 

wire EQ, NEQ, GT, LT, GTE, LTE, OVFL, UNCOND; 

assign NEQ = ~F[2] & ~C[2] & ~C[1] & ~C[0]; 
assign EQ = F[2] & ~C[2] & ~C[1] & C[0]; 
assign GT = ~F[2] & ~F[0] & ~C[2] & ~C[1] & C[0]; 
assign LT = F[0] & ~C[2] & C[1] & C[0]; 
assign GTE = (F[2] | (~F[2] & ~F[0])) & C[2] & ~C[1] & ~C[0]; 
assign LTE = (F[2] | F[0]) & C[2] & ~C[1] & C[0]; 
assign OVFL = F[1] & C[2] & C[1] & ~C[0]; 
assign UNCOND = C[2] & C[1] & C[0]; //ccc = 111

assign Branch = NEQ | EQ | GT | LT | GTE | LTE | OVFL | UNCOND; 

endmodule
