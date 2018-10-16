// for LLB and LHB instructions
module ByteLoader(in, u, high, out);
    input[15:0] in; // 16bit input
    input[7:0] u; // the byte to be loaded
    input high; // if it's LHB
    output[15:0] out;

    assign out = high == 1'b1 ? {u, in[7:0]} : {in[15:8], u};
endmodule