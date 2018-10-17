
module RED (A, B, Reduction); 

input [15:0] A, B;
output [15:0] Reduction; 
wire [8:0] temp1, temp2;
wire [9:0] temp3; 

adder_8bit ADD1(.Sum(temp1), .A(A[15:8]), .B(B[15:8]));
adder_8bit ADD2(.Sum(temp2), .A(A[7:0]), .B(B[7:0])); 

adder_9bit ADD3(.Sum(temp3), .A(temp1), .B(temp2)); 

assign Reduction = {{6{temp3[9]}}, temp3}; //SIGN EXTENDED 10-bit temp TO 16-BIT

endmodule 
