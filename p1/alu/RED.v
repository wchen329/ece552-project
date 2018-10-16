module RED (A, B, Reduction); 

input [15:0] A, B;
output [15:0] Reduction; 
wire [7:0] temp1, temp2, temp3;

adder_8bit_cla_simple ADD1(temp1, A[15:8], B[15:8]);
adder_8bit_cla_simple ADD2(temp2, A[7:0], B[7:0]); 
adder_8bit_cla_simple ADD3(temp3, temp1, temp2); 

  assign Reduction = {{8{temp3[7]}}, temp3}; 




endmodule 
