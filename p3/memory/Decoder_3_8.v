/* Procedurally generated decoder. 
 * Generated using decoderGen script.
 */
module Decoder_3_8(decode_in, decode_out);
	input[2:0] decode_in;
	output[7:0] decode_out;
	assign decode_out =
		decode_in == 0 ? 8'b00000001 :
		decode_in == 1 ? 8'b00000010 :
		decode_in == 2 ? 8'b00000100 :
		decode_in == 3 ? 8'b00001000 :
		decode_in == 4 ? 8'b00010000 :
		decode_in == 5 ? 8'b00100000 :
		decode_in == 6 ? 8'b01000000 :
		decode_in == 7 ? 8'b10000000 :
		0;
endmodule