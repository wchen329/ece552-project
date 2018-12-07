% decoderGen
%
% A simple script that generates a specified bit length decoder
%
% wchen329
decoder_input_length = 7; % change this value for different size decoder
decode_file = fopen('Decoder_' + string(decoder_input_length) + '_' + string(2^decoder_input_length) +'.v', 'w');
fprintf(decode_file, "/* Procedurally generated decoder. \n * Generated using decoderGen script.\n */\n"); 
fprintf(decode_file, "module Decoder_" + string(decoder_input_length) + '_' + string(2^decoder_input_length) + "(decode_in, decode_out);\n");
fprintf(decode_file, "\tinput[" + string(decoder_input_length - 1) + ":0] decode_in;\n" );
fprintf(decode_file, "\toutput[" + string(2^(decoder_input_length) - 1) + ":0] decode_out;\n" );
fprintf(decode_file, "\tassign decode_out =\n");
ind_end = 2^decoder_input_length - 1;
count = 0;
for ind = 0:1:ind_end
    vec_str = string(2^decoder_input_length) + "'b";
    for zero_arr = 0:1:(2^decoder_input_length - 1)
        if zero_arr == (2^decoder_input_length - 1 - count)
           vec_str = vec_str + '1';
            count = count + 1;
        else
           vec_str = vec_str + '0';
        end
    end
    fprintf(decode_file, '\t\tdecode_in == %d ? ' + vec_str, round(ind));
    fprintf(decode_file, ' :\n');
end
fprintf(decode_file, "\t\t0;\n"); % print default case that can't happen
fprintf(decode_file, "endmodule");