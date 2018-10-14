module FlagRegister(clk, rst_n, we, flag_in, flag_out);
    input clk, rst_n; // posedge trigger, sync active low reset
    input[2:0] we, flag_in; // {Z,V,N} order may be changed, active high write enable, e.g. if we[2]==1, then Z will be set to flag_in[2];
    output[2:0] flag_out;

    dff flagZ(.q(flag_out[2]), .d(flag_in[2]), .wen(we[2]), .clk(clk), .rst(~rst_n));
    dff flagV(.q(flag_out[1]), .d(flag_in[1]), .wen(we[1]), .clk(clk), .rst(~rst_n));
    dff flagN(.q(flag_out[0]), .d(flag_in[0]), .wen(we[0]), .clk(clk), .rst(~rst_n));
endmodule