/* A shifter implemented through 3-1 muxes.
 *
 * wchen329@wisc.edu
 */
module Shifter_3_1(Shift_Out, Shift_In, Shift_Val, Opcode);

input [15:0] Shift_In;
input [3:0] Shift_Val;
input [2:0] Opcode;
output [15:0] Shift_Out;

wire[1:0] s_level0, s_level1, s_level2;
wire[15:0] sll_out, sra_out, ror_out;

// Create lookup table of base 3 select inputs
assign s_level0 = Shift_Val == 0 ? 0 :
		  Shift_Val == 1 ? 1 :
		  Shift_Val == 2 ? 2 :
		  Shift_Val == 3 ? 0 :
		  Shift_Val == 4 ? 1 :
		  Shift_Val == 5 ? 2 :
		  Shift_Val == 6 ? 0 :
		  Shift_Val == 7 ? 1 :
		  Shift_Val == 8 ? 2 :
		  Shift_Val == 9 ? 0 :
		  Shift_Val == 10 ? 1 :
		  Shift_Val == 11 ? 2 :
		  Shift_Val == 12 ? 0 :
		  Shift_Val == 13 ? 1 :
		  Shift_Val == 14 ? 2 :
		  Shift_Val == 15 ? 0 : 0;

assign s_level1 = Shift_Val == 0 ? 0 :
		  Shift_Val == 1 ? 0 :
		  Shift_Val == 2 ? 0 :
		  Shift_Val == 3 ? 1 :
		  Shift_Val == 4 ? 1 :
		  Shift_Val == 5 ? 1 :
		  Shift_Val == 6 ? 2 :
		  Shift_Val == 7 ? 2 :
		  Shift_Val == 8 ? 2 :
		  Shift_Val == 9 ? 0 :
		  Shift_Val == 10 ? 0 :
		  Shift_Val == 11 ? 0 :
		  Shift_Val == 12 ? 1 :
		  Shift_Val == 13 ? 1 :
		  Shift_Val == 14 ? 1 :
		  Shift_Val == 15 ? 2 : 0;

assign s_level2 = Shift_Val == 0 ? 0 :
		  Shift_Val == 1 ? 0 :
		  Shift_Val == 2 ? 0 :
		  Shift_Val == 3 ? 0 :
		  Shift_Val == 4 ? 0 :
		  Shift_Val == 5 ? 0 :
		  Shift_Val == 6 ? 0 :
		  Shift_Val == 7 ? 0 :
		  Shift_Val == 8 ? 0 :
		  Shift_Val == 9 ? 1 :
		  Shift_Val == 10 ? 1 :
		  Shift_Val == 11 ? 1 :
		  Shift_Val == 12 ? 1 :
		  Shift_Val == 13 ? 1 :
		  Shift_Val == 14 ? 1 :
		  Shift_Val == 15 ? 1 : 0;

// SLL
wire[15:0] sll_1, sll_2, sll_3, sll_6, sll_9, SLL_In_L1, SLL_In_L2;
assign sll_1 = Shift_In << 1; assign sll_2 = Shift_In << 2;
assign sll_3 = SLL_In_L1 << 3; assign sll_6 = SLL_In_L1 << 6;
assign sll_9 = SLL_In_L2 << 9;

mux_3_1_array_16 LEVEL_0_LL(SLL_In_L1 , Shift_In, sll_1, sll_2, s_level0);
mux_3_1_array_16 LEVEL_1_LL(SLL_In_L2 , SLL_In_L1, sll_3, sll_6, s_level1);
mux_3_1_array_16 LEVEL_2_LL(sll_out , SLL_In_L2, sll_9, {16{1'b0}}, s_level2);

// SRA
wire[15:0] sra_1, sra_2, sra_3, sra_6, sra_9, SRA_In_L1, SRA_In_L2;
assign sra_1 = {Shift_In[15], Shift_In[15:1]}; assign sra_2 = {Shift_In[15], Shift_In[15], Shift_In[15:2]};
assign sra_3 = {{3{SRA_In_L1[15]}}, SRA_In_L1[15:3]}; assign sra_6 = {{6{SRA_In_L1[15]}}, SRA_In_L1[15:6]};
assign sra_9 = {{9{SRA_In_L2[15]}}, SRA_In_L2[15:9]};

mux_3_1_array_16 LEVEL_0_RA(SRA_In_L1 , Shift_In, sra_1, sra_2, s_level0);
mux_3_1_array_16 LEVEL_1_RA(SRA_In_L2 , SRA_In_L1, sra_3, sra_6, s_level1);
mux_3_1_array_16 LEVEL_2_RA(sra_out , SRA_In_L2, sra_9, {16{1'b0}}, s_level2);

// ROR
wire[15:0] ror_1, ror_2, ror_3, ror_6, ror_9, ROR_In_L1, ROR_In_L2;
assign ror_1 = {Shift_In[0], Shift_In[15:1]}; assign ror_2 = {Shift_In[1], Shift_In[0], Shift_In[15:2]};
assign ror_3 = {ROR_In_L1[2], ROR_In_L1[1], ROR_In_L1[0], ROR_In_L1[15:3]};
assign ror_6 = {ROR_In_L1[5], ROR_In_L1[4], ROR_In_L1[3], ROR_In_L1[2], ROR_In_L1[1], ROR_In_L1[0], ROR_In_L1[15:6]};
assign ror_9 = {ROR_In_L2[8], ROR_In_L2[7], ROR_In_L2[6], ROR_In_L2[5], ROR_In_L2[4], ROR_In_L2[3], ROR_In_L2[2], ROR_In_L2[1], ROR_In_L2[0], ROR_In_L2[15:9]};

mux_3_1_array_16 LEVEL_0_RO(ROR_In_L1 , Shift_In, ror_1, ror_2, s_level0);
mux_3_1_array_16 LEVEL_1_RO(ROR_In_L2 , ROR_In_L1, ror_3, ror_6, s_level1);
mux_3_1_array_16 LEVEL_2_RO(ror_out , ROR_In_L2, ror_9, {16{1'b0}}, s_level2);

assign Shift_Out = Opcode[1:0] == 0 ? sll_out :
		   Opcode[1:0] == 1 ? sra_out :
		   Opcode[1:0] == 2 ? ror_out : 0; 

endmodule
