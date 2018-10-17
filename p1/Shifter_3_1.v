/* A shifter implemented through 3-1 muxes.
 *
 * wchen329@wisc.edu
 */
module Shifter_3_1(Shift_Out, Shift_In, Shift_Val, Opcode);

input [15:0] Shift_In;
input [3:0] Shift_Val;
input [2:0] Opcode;
output [15:0] Shift_Out;

wire[15:0] sll_out, sra_out, ror_out;

// SLL
wire[15:0] sll_1, sll_2, sll_3, sll_6, sll_9, SLL_In_L1, SLL_In_L2;
assign sll_1 = Shift_In << 1; assign sll_2 = Shift_In << 2;
assign sll_3 = SLL_In_L1 << 3; assign sll_6 = SLL_In_L1 << 6;
assign sll_9 = SLL_In_L2 << 9;

mux_3_1_array_16 LEVEL_0_LL(SLL_In_L1 , Shift_In, sll_1, sll_2, 2);
mux_3_1_array_16 LEVEL_1_LL(SLL_In_L2 , SLL_In_L1, sll_3, sll_6, 2);
mux_3_1_array_16 LEVEL_2_LL(sll_out , SLL_In_L2, sll_9, 0, 2);

// SRA
wire[15:0] sra_1, sra_2, sra_3, sra_6, sra_9, SRA_In_L1, SRA_In_L2;
assign sra_1 = {Shift_In[15], Shift_In[15:1]}; assign sra_2 = {Shift_In[15], Shift_In[15], Shift_In[15:2]};
assign sra_3 = {{3{SRA_In_L1[15]}}, SRA_In_L1[15:3]}; assign sra_6 = {{6{SRA_In_L1[15]}}, SRA_In_L1[15:6]};
assign sra_9 = {{9{SRA_In_L2[15]}}, SRA_In_L2[15:9]};

mux_3_1_array_16 LEVEL_0_RA(SRA_In_L1 , Shift_In, sra_1, sra_2, 2);
mux_3_1_array_16 LEVEL_1_RA(SRA_In_L2 , SRA_In_L1, sra_3, sra_6, 2);
mux_3_1_array_16 LEVEL_2_RA(sra_out , SRA_In_L2, sra_9, 0, 2);

// ROR
wire[15:0] ror_1, ror_2, ror_3, ror_6, ror_9, ROR_In_L1, ROR_In_L2;
assign ror_1 = {Shift_In[0], Shift_In[15:1]}; assign ror_2 = {Shift_In[1], Shift_In[0], Shift_In[15:2]};
assign ror_3 = {ROR_In_L1[2], ROR_In_L1[1], ROR_In_L1[0], ROR_In_L1[15:3]};
assign ror_6 = {ROR_In_L1[5], ROR_In_L1[4], ROR_In_L1[3], ROR_In_L1[2], ROR_In_L1[1], ROR_In_L1[0], ROR_In_L1[15:6]};
assign ror_9 = {ROR_In_L1[8], ROR_In_L1[7], ROR_In_L1[6], ROR_In_L1[5], ROR_In_L1[4], ROR_In_L1[3], ROR_In_L1[2], ROR_In_L1[1], ROR_In_L1[0], ROR_In_L2[15:9]};

mux_3_1_array_16 LEVEL_0_RO(ROR_In_L1 , Shift_In, ror_1, ror_2, 2);
mux_3_1_array_16 LEVEL_1_RO(ROR_In_L2 , ROR_In_L1, ror_3, ror_6, 2);
mux_3_1_array_16 LEVEL_2_RO(ror_out , ROR_In_L2, ror_9, 0, 2);

endmodule
