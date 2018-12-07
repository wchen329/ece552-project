/* Procedurally generated decoder. 
 * Generated using decoderGen script.
 */
module Decoder_6-64(decode_in, decode_out);
	input[5:0] decode_in;
	output[63:0] decode_out;
	assign decode_out =
		decode_in == 0 ? 64'b0000000000000000000000000000000000000000000000000000000000000001 :
		decode_in == 1 ? 64'b0000000000000000000000000000000000000000000000000000000000000010 :
		decode_in == 2 ? 64'b0000000000000000000000000000000000000000000000000000000000000100 :
		decode_in == 3 ? 64'b0000000000000000000000000000000000000000000000000000000000001000 :
		decode_in == 4 ? 64'b0000000000000000000000000000000000000000000000000000000000010000 :
		decode_in == 5 ? 64'b0000000000000000000000000000000000000000000000000000000000100000 :
		decode_in == 6 ? 64'b0000000000000000000000000000000000000000000000000000000001000000 :
		decode_in == 7 ? 64'b0000000000000000000000000000000000000000000000000000000010000000 :
		decode_in == 8 ? 64'b0000000000000000000000000000000000000000000000000000000100000000 :
		decode_in == 9 ? 64'b0000000000000000000000000000000000000000000000000000001000000000 :
		decode_in == 10 ? 64'b0000000000000000000000000000000000000000000000000000010000000000 :
		decode_in == 11 ? 64'b0000000000000000000000000000000000000000000000000000100000000000 :
		decode_in == 12 ? 64'b0000000000000000000000000000000000000000000000000001000000000000 :
		decode_in == 13 ? 64'b0000000000000000000000000000000000000000000000000010000000000000 :
		decode_in == 14 ? 64'b0000000000000000000000000000000000000000000000000100000000000000 :
		decode_in == 15 ? 64'b0000000000000000000000000000000000000000000000001000000000000000 :
		decode_in == 16 ? 64'b0000000000000000000000000000000000000000000000010000000000000000 :
		decode_in == 17 ? 64'b0000000000000000000000000000000000000000000000100000000000000000 :
		decode_in == 18 ? 64'b0000000000000000000000000000000000000000000001000000000000000000 :
		decode_in == 19 ? 64'b0000000000000000000000000000000000000000000010000000000000000000 :
		decode_in == 20 ? 64'b0000000000000000000000000000000000000000000100000000000000000000 :
		decode_in == 21 ? 64'b0000000000000000000000000000000000000000001000000000000000000000 :
		decode_in == 22 ? 64'b0000000000000000000000000000000000000000010000000000000000000000 :
		decode_in == 23 ? 64'b0000000000000000000000000000000000000000100000000000000000000000 :
		decode_in == 24 ? 64'b0000000000000000000000000000000000000001000000000000000000000000 :
		decode_in == 25 ? 64'b0000000000000000000000000000000000000010000000000000000000000000 :
		decode_in == 26 ? 64'b0000000000000000000000000000000000000100000000000000000000000000 :
		decode_in == 27 ? 64'b0000000000000000000000000000000000001000000000000000000000000000 :
		decode_in == 28 ? 64'b0000000000000000000000000000000000010000000000000000000000000000 :
		decode_in == 29 ? 64'b0000000000000000000000000000000000100000000000000000000000000000 :
		decode_in == 30 ? 64'b0000000000000000000000000000000001000000000000000000000000000000 :
		decode_in == 31 ? 64'b0000000000000000000000000000000010000000000000000000000000000000 :
		decode_in == 32 ? 64'b0000000000000000000000000000000100000000000000000000000000000000 :
		decode_in == 33 ? 64'b0000000000000000000000000000001000000000000000000000000000000000 :
		decode_in == 34 ? 64'b0000000000000000000000000000010000000000000000000000000000000000 :
		decode_in == 35 ? 64'b0000000000000000000000000000100000000000000000000000000000000000 :
		decode_in == 36 ? 64'b0000000000000000000000000001000000000000000000000000000000000000 :
		decode_in == 37 ? 64'b0000000000000000000000000010000000000000000000000000000000000000 :
		decode_in == 38 ? 64'b0000000000000000000000000100000000000000000000000000000000000000 :
		decode_in == 39 ? 64'b0000000000000000000000001000000000000000000000000000000000000000 :
		decode_in == 40 ? 64'b0000000000000000000000010000000000000000000000000000000000000000 :
		decode_in == 41 ? 64'b0000000000000000000000100000000000000000000000000000000000000000 :
		decode_in == 42 ? 64'b0000000000000000000001000000000000000000000000000000000000000000 :
		decode_in == 43 ? 64'b0000000000000000000010000000000000000000000000000000000000000000 :
		decode_in == 44 ? 64'b0000000000000000000100000000000000000000000000000000000000000000 :
		decode_in == 45 ? 64'b0000000000000000001000000000000000000000000000000000000000000000 :
		decode_in == 46 ? 64'b0000000000000000010000000000000000000000000000000000000000000000 :
		decode_in == 47 ? 64'b0000000000000000100000000000000000000000000000000000000000000000 :
		decode_in == 48 ? 64'b0000000000000001000000000000000000000000000000000000000000000000 :
		decode_in == 49 ? 64'b0000000000000010000000000000000000000000000000000000000000000000 :
		decode_in == 50 ? 64'b0000000000000100000000000000000000000000000000000000000000000000 :
		decode_in == 51 ? 64'b0000000000001000000000000000000000000000000000000000000000000000 :
		decode_in == 52 ? 64'b0000000000010000000000000000000000000000000000000000000000000000 :
		decode_in == 53 ? 64'b0000000000100000000000000000000000000000000000000000000000000000 :
		decode_in == 54 ? 64'b0000000001000000000000000000000000000000000000000000000000000000 :
		decode_in == 55 ? 64'b0000000010000000000000000000000000000000000000000000000000000000 :
		decode_in == 56 ? 64'b0000000100000000000000000000000000000000000000000000000000000000 :
		decode_in == 57 ? 64'b0000001000000000000000000000000000000000000000000000000000000000 :
		decode_in == 58 ? 64'b0000010000000000000000000000000000000000000000000000000000000000 :
		decode_in == 59 ? 64'b0000100000000000000000000000000000000000000000000000000000000000 :
		decode_in == 60 ? 64'b0001000000000000000000000000000000000000000000000000000000000000 :
		decode_in == 61 ? 64'b0010000000000000000000000000000000000000000000000000000000000000 :
		decode_in == 62 ? 64'b0100000000000000000000000000000000000000000000000000000000000000 :
		decode_in == 63 ? 64'b1000000000000000000000000000000000000000000000000000000000000000 :
		0;
endmodule