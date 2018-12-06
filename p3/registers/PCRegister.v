module PCRegister(clk, rst, we, P, Q);
    input clk, rst, we; // posedge trigger, sync active high reset, active high write enable
    input[15:0] P; // new execution addr
    output[15:0] Q; // current execution addr;

    dff bit0(.q(Q[0]), .d(P[0]), .wen(we), .clk(clk), .rst(rst));
    dff bit1(.q(Q[1]), .d(P[1]), .wen(we), .clk(clk), .rst(rst));
    dff bit2(.q(Q[2]), .d(P[2]), .wen(we), .clk(clk), .rst(rst));
    dff bit3(.q(Q[3]), .d(P[3]), .wen(we), .clk(clk), .rst(rst));
    dff bit4(.q(Q[4]), .d(P[4]), .wen(we), .clk(clk), .rst(rst));
    dff bit5(.q(Q[5]), .d(P[5]), .wen(we), .clk(clk), .rst(rst));
    dff bit6(.q(Q[6]), .d(P[6]), .wen(we), .clk(clk), .rst(rst));
    dff bit7(.q(Q[7]), .d(P[7]), .wen(we), .clk(clk), .rst(rst));
    dff bit8(.q(Q[8]), .d(P[8]), .wen(we), .clk(clk), .rst(rst));
    dff bit9(.q(Q[9]), .d(P[9]), .wen(we), .clk(clk), .rst(rst));
    dff bit10(.q(Q[10]), .d(P[10]), .wen(we), .clk(clk), .rst(rst));
    dff bit11(.q(Q[11]), .d(P[11]), .wen(we), .clk(clk), .rst(rst));
    dff bit12(.q(Q[12]), .d(P[12]), .wen(we), .clk(clk), .rst(rst));
    dff bit13(.q(Q[13]), .d(P[13]), .wen(we), .clk(clk), .rst(rst));
    dff bit14(.q(Q[14]), .d(P[14]), .wen(we), .clk(clk), .rst(rst));
    dff bit15(.q(Q[15]), .d(P[15]), .wen(we), .clk(clk), .rst(rst));
endmodule
