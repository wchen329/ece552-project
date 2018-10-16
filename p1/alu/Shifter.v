
module Shifter(Shift_Out, Shift_In, Shift_Val, Opcode, Z); 

input [15:0] Shift_In;
input [3:0] Shift_Val;
output [15:0] Shift_Out;
input [3:0] Opcode; 
output Z;
wire Z_sll, Z_sra, Z_ror;


// SLL
wire [15:0] sll_out, sll_out_s1, sll_out_s2, sll_out_s3;
assign sll_out_s1 = Shift_Val[0] == 0 ? Shift_In : {Shift_In[14:0], 1'b0}; // account for shift 1
assign sll_out_s2 = Shift_Val[1] == 0 ? sll_out_s1 : {sll_out_s1[13:0], {2{1'b0}} }; // account for shift 2
assign sll_out_s3 = Shift_Val[2] == 0 ? sll_out_s2 : {sll_out_s2[11:0], {4{1'b0}} }; // account for shift 4
assign sll_out = Shift_Val[3] == 0 ? sll_out_s3 : {sll_out_s3[7:0], {8{1'b0}} }; // account for shift 8
assign Z_sll = &sll_out ? 0 : 1; 

// SRA
wire [15:0] sra_out, sra_out_s1, sra_out_s2, sra_out_s3;
assign sra_out_s1 = Shift_Val[0] == 0 ? Shift_In : {Shift_In[15], Shift_In[15:1]}; // account for shift 1
assign sra_out_s2 = Shift_Val[1] == 0 ? sra_out_s1 : { {2{sra_out_s1[15]}}, sra_out_s1[15:2] }; // account for shift 2
assign sra_out_s3 = Shift_Val[2] == 0 ? sra_out_s2 : { {4{sra_out_s2[15]}}, sra_out_s2[15:4] }; // account for shift 4
assign sra_out = Shift_Val[3] == 0 ? sra_out_s3 : { {8{sra_out_s3[15]}}, sra_out_s3[15:8] }; // account for shift 8
assign Z_sra = &sra_out ? 0 : 1; 

// ROR
wire [15:0] ror_out, ror_out_s1, ror_out_s2, ror_out_s3; 
assign ror_out_s1 = Shift_Val[0] == 0 ? Shift_In : {Shift_In[0], Shift_In[15:1]};
assign ror_out_s2 = Shift_Val[1] == 0 ? ror_out_s1 : {ror_out_s1[1:0], Shift_In[15:2]};
assign ror_out_s3 = Shift_Val[2] == 0 ? ror_out_s2 : {ror_out_s2[3:0], Shift_In[15:4]};
assign ror_out = Shift_Val[3] == 0 ? ror_out_s3 : {ror_out_s3[7:0], Shift_In[15:8]};
assign Z_ror = &ror_out ? 0 : 1; 

assign Shift_Out = Opcode[1]? ror_out:
		Opcode[0]? sra_out:
		sll_out;
assign Z = Opcode[1]?Z_ror:
	Opcode[0]? Z_sra:
	Z_sll; 
endmodule
