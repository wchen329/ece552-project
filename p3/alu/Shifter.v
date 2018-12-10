/* A 3-1 Mux
 *
 * Due to having extra selections, they're assigned as follows:
 * 0 - input 0
 * 1 - input 1
 * 2 - input 2
 * 3 - input 2
 *
 * wchen329@wisc.edu
 */
module mux_3_1(output selected_val, input val_0, input val_1, input val_2, input[1:0] select);

	// It'd be nice to be able to use a 4-1 mux...
	assign selected_val = select == 0 ? val_0 :
			       select == 1 ? val_1 :
			       select == 2 ? val_2 :
			       select == 3 ? val_2 : 0;
endmodule

/* An array of 16 3-1 muxes
 * Module is basically a super mux that accept 16 bit buses rather than singleton nets.
 * So input is is a 16 bit array each bit representing ONE input to ONE mux in that array.
 * i.e. the 0 input to mux_0 is in_0[0].
 *
 * wchen329@wisc.edu
 */
module mux_3_1_array_16(output[15:0] bus_out, input[15:0] in_0, in_1, in_2, input[1:0] select);

	mux_3_1 MUX_0(.selected_val(bus_out[0]), .val_0(in_0[0]), .val_1(in_1[0]), .val_2(in_2[0]), .select(select)); 
	mux_3_1 MUX_1(.selected_val(bus_out[1]), .val_0(in_0[1]), .val_1(in_1[1]), .val_2(in_2[1]), .select(select)); 
	mux_3_1 MUX_2(.selected_val(bus_out[2]), .val_0(in_0[2]), .val_1(in_1[2]), .val_2(in_2[2]), .select(select)); 
	mux_3_1 MUX_3(.selected_val(bus_out[3]), .val_0(in_0[3]), .val_1(in_1[3]), .val_2(in_2[3]), .select(select)); 
	mux_3_1 MUX_4(.selected_val(bus_out[4]), .val_0(in_0[4]), .val_1(in_1[4]), .val_2(in_2[4]), .select(select)); 
	mux_3_1 MUX_5(.selected_val(bus_out[5]), .val_0(in_0[5]), .val_1(in_1[5]), .val_2(in_2[5]), .select(select)); 
	mux_3_1 MUX_6(.selected_val(bus_out[6]), .val_0(in_0[6]), .val_1(in_1[6]), .val_2(in_2[6]), .select(select)); 
	mux_3_1 MUX_7(.selected_val(bus_out[7]), .val_0(in_0[7]), .val_1(in_1[7]), .val_2(in_2[7]), .select(select)); 
	mux_3_1 MUX_8(.selected_val(bus_out[8]), .val_0(in_0[8]), .val_1(in_1[8]), .val_2(in_2[8]), .select(select)); 
	mux_3_1 MUX_9(.selected_val(bus_out[9]), .val_0(in_0[9]), .val_1(in_1[9]), .val_2(in_2[9]), .select(select)); 
	mux_3_1 MUX_10(.selected_val(bus_out[10]), .val_0(in_0[10]), .val_1(in_1[10]), .val_2(in_2[10]), .select(select)); 
	mux_3_1 MUX_11(.selected_val(bus_out[11]), .val_0(in_0[11]), .val_1(in_1[11]), .val_2(in_2[11]), .select(select)); 
	mux_3_1 MUX_12(.selected_val(bus_out[12]), .val_0(in_0[12]), .val_1(in_1[12]), .val_2(in_2[12]), .select(select)); 
	mux_3_1 MUX_13(.selected_val(bus_out[13]), .val_0(in_0[13]), .val_1(in_1[13]), .val_2(in_2[13]), .select(select)); 
	mux_3_1 MUX_14(.selected_val(bus_out[14]), .val_0(in_0[14]), .val_1(in_1[14]), .val_2(in_2[14]), .select(select)); 
	mux_3_1 MUX_15(.selected_val(bus_out[15]), .val_0(in_0[15]), .val_1(in_1[15]), .val_2(in_2[15]), .select(select)); 

endmodule

/* A shifter implemented through 3-1 muxes.
 *
 * wchen329@wisc.edu
 */
module Shifter(Shift_Out, Shift_In, Shift_Val, Opcode);

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


mux_3_1_array_16 LEVEL_0_LL(.bus_out(SLL_In_L1), .in_0(Shift_In), .in_1(sll_1), .in_2(sll_2), .select(s_level0));
mux_3_1_array_16 LEVEL_1_LL(.bus_out(SLL_In_L2), .in_0(SLL_In_L1), .in_1(sll_3), .in_2(sll_6), .select(s_level1));
mux_3_1_array_16 LEVEL_2_LL(.bus_out(sll_out), .in_0(SLL_In_L2), .in_1(sll_9), .in_2({16{1'b0}}), .select(s_level2));


// SRA
wire[15:0] sra_1, sra_2, sra_3, sra_6, sra_9, SRA_In_L1, SRA_In_L2;
assign sra_1 = {Shift_In[15], Shift_In[15:1]}; assign sra_2 = {Shift_In[15], Shift_In[15], Shift_In[15:2]};
assign sra_3 = {{3{SRA_In_L1[15]}}, SRA_In_L1[15:3]}; assign sra_6 = {{6{SRA_In_L1[15]}}, SRA_In_L1[15:6]};
assign sra_9 = {{9{SRA_In_L2[15]}}, SRA_In_L2[15:9]};

mux_3_1_array_16 LEVEL_0_RA(.bus_out(SRA_In_L1), .in_0(Shift_In), .in_1(sra_1), .in_2(sra_2), .select(s_level0));
mux_3_1_array_16 LEVEL_1_RA(.bus_out(SRA_In_L2), .in_0(SRA_In_L1), .in_1(sra_3), .in_2(sra_6), .select(s_level1));
mux_3_1_array_16 LEVEL_2_RA(.bus_out(sra_out), .in_0(SRA_In_L2), .in_1(sra_9), .in_2({16{1'b0}}), .select(s_level2));

// ROR
wire[15:0] ror_1, ror_2, ror_3, ror_6, ror_9, ROR_In_L1, ROR_In_L2;
assign ror_1 = {Shift_In[0], Shift_In[15:1]}; assign ror_2 = {Shift_In[1], Shift_In[0], Shift_In[15:2]};
assign ror_3 = {ROR_In_L1[2], ROR_In_L1[1], ROR_In_L1[0], ROR_In_L1[15:3]};
assign ror_6 = {ROR_In_L1[5], ROR_In_L1[4], ROR_In_L1[3], ROR_In_L1[2], ROR_In_L1[1], ROR_In_L1[0], ROR_In_L1[15:6]};
assign ror_9 = {ROR_In_L2[8], ROR_In_L2[7], ROR_In_L2[6], ROR_In_L2[5], ROR_In_L2[4], ROR_In_L2[3], ROR_In_L2[2], ROR_In_L2[1], ROR_In_L2[0], ROR_In_L2[15:9]};

mux_3_1_array_16 LEVEL_0_RO(.bus_out(ROR_In_L1), .in_0(Shift_In), .in_1(ror_1), .in_2(ror_2), .select(s_level0));
mux_3_1_array_16 LEVEL_1_R0(.bus_out(ROR_In_L2), .in_0(ROR_In_L1), .in_1(ror_3), .in_2(ror_6), .select(s_level1));
mux_3_1_array_16 LEVEL_2_R0(.bus_out(ror_out), .in_0(ROR_In_L2), .in_1(ror_9), .in_2({16{1'b0}}), .select(s_level2));


assign Shift_Out = Opcode[1:0] == 0 ? sll_out :
		   Opcode[1:0] == 1 ? sra_out :
		   Opcode[1:0] == 2 ? ror_out : 0;

endmodule
