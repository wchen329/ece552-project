module FlagRegister(clk, rst, weZVN, flagZVN_in, flagZVN_out);
    input clk, rst;       // posedge trigger, sync active high reset
    input[2:0] weZVN, flagZVN_in; // {Z,V,N} order may be changed, active high write enable, e.g. if we[2]==1, then Z will be set to flag_in[2];
    output[2:0] flagZVN_out;

    wire[2:0] flag_out; // flipflop output

    dff flagZ(.q(flag_out[2]), .d(flagZVN_in[2]), .wen(weZVN[2]), .clk(clk), .rst(rst));
    dff flagV(.q(flag_out[1]), .d(flagZVN_in[1]), .wen(weZVN[1]), .clk(clk), .rst(rst));
    dff flagN(.q(flag_out[0]), .d(flagZVN_in[0]), .wen(weZVN[0]), .clk(clk), .rst(rst));

    // passthrough
    assign flagZVN_out = {
        weZVN[2] ? flagZVN_in[2] : flag_out[2],
        weZVN[1] ? flagZVN_in[1] : flag_out[1],
        weZVN[0] ? flagZVN_in[0] : flag_out[0]
    };
endmodule