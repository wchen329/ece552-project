module RED (A, B, Reduction); 

input [15:0] A, B;
output [15:0] Reduction; 
wire [7:0] temp1, temp2, temp3;
wire Ov1, Ov2, Ov3;

adder_2byte ADD1(temp1, Ov1, A[15:8], B[15:8]);
adder_2byte ADD2(temp2, Ov2, A[7:0], B[7:0]); 

adder_2byte ADD3(temp3, Ov3, temp1, temp2); 

assign Reduction = {temp3[7], temp3[7], temp3[7], temp3[7], temp3[7], temp3[7], temp3[7], temp3[7], temp3}; 




endmodule 
