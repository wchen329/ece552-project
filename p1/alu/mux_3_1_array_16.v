/* An array of 16 3-1 muxes
 * Module is basically a super mux that accept 16 bit buses rather than singleton nets.
 * So input is is a 16 bit array each bit representing ONE input to ONE mux in that array.
 * i.e. the 0 input to mux_0 is in_0[0].
 * 
 * wchen329@wisc.edu
 */
module mux_3_1_array_16(output[15:0] bus_out, input[15:0] in_0, in_1, in_2, input[1:0] select);

	mux_3_1 MUX_0(bus_out[0], in_0[0], in_1[0], in_2[0], select);
	mux_3_1 MUX_1(bus_out[1], in_0[1], in_1[1], in_2[1], select);
	mux_3_1 MUX_2(bus_out[2], in_0[2], in_1[2], in_2[2], select);
	mux_3_1 MUX_3(bus_out[3], in_0[3], in_1[3], in_2[3], select);
	mux_3_1 MUX_4(bus_out[4], in_0[4], in_1[4], in_2[4], select);
	mux_3_1 MUX_5(bus_out[5], in_0[5], in_1[5], in_2[5], select);
	mux_3_1 MUX_6(bus_out[6], in_0[6], in_1[6], in_2[6], select);
	mux_3_1 MUX_7(bus_out[7], in_0[7], in_1[7], in_2[7], select);
	mux_3_1 MUX_8(bus_out[8], in_0[8], in_1[8], in_2[8], select);
	mux_3_1 MUX_9(bus_out[9], in_0[9], in_1[9], in_2[9], select);
	mux_3_1 MUX_10(bus_out[10], in_0[10], in_1[10], in_2[10], select);
	mux_3_1 MUX_11(bus_out[11], in_0[11], in_1[11], in_2[11], select);
	mux_3_1 MUX_12(bus_out[12], in_0[12], in_1[12], in_2[12], select);
	mux_3_1 MUX_13(bus_out[13], in_0[13], in_1[13], in_2[13], select);
	mux_3_1 MUX_14(bus_out[14], in_0[14], in_1[14], in_2[14], select);
	mux_3_1 MUX_15(bus_out[15], in_0[15], in_1[15], in_2[15], select);

endmodule