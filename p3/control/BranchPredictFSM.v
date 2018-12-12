/* 2-bit branch prediction by Zhenghao Gu */

module BranchPredictFSM(
    input clk, rst, stall,

    input [15:0] pcIn,          // current pc from IF
    input [15:0] instIn,        // current inst from IF
    output[15:0] predictPcOut,  // combinational output, the predicted next pc (pc+2 or pc+2+offset). If not B instruction, then set to pcIn+2.

    input        taken,         // the "taken" signal from PC_Control (from ID stage).
                                // when a branch instruction is fed into the FSM, the FSM goes into the "waiting for branch result" state
                                // and monitor this signal in the next cycle (when PC_Control in ID stage made the decision)
    output       mispredicted   // if a mispredict happen. Some, if not all, "taken" signal in cpu.v should be replaced by this.
);
    // note that a BR instruction is always predicted to be "not taken"

    wire strong_nt, weak_nt, weak_t, strong_t;
    wire[1:0] next_t, current_t, prev_t;    // 0=snt(strong not take), 1=wnt, 2=wt, 3=st

    wire not_waiting, waiting_b, waiting_br;
    wire [1:0]next_waiting; // 0=not waiting 1=waiting_b 2=waiting_br

    wire [8:0]  offset;
    wire [15:0] branchTarget; // where to jump if taken,

    // 8 states in total {strong_not_take,weak_not_take,weak_take,strong_take} * {not_waiting, waiting}
    dff _prev_stat[1:0] (.d(current_t), .q(prev_t), .wen(~stall), .clk(clk), .rst(1'b0));
    dff state_strong_not_take(.d(rst ? 1'b1 : next_t == 2'b00), .q(strong_nt), .wen(~stall), .clk(clk), .rst(1'b0));
    dff state_weak_not_take  (.d(rst ? 1'b0 : next_t == 2'b01), .q(weak_nt),   .wen(~stall), .clk(clk), .rst(1'b0));
    dff state_weak_take      (.d(rst ? 1'b0 : next_t == 2'b10), .q(weak_t),    .wen(~stall), .clk(clk), .rst(1'b0));
    dff state_strong_take    (.d(rst ? 1'b0 : next_t == 2'b11), .q(strong_t),  .wen(~stall), .clk(clk), .rst(1'b0));

    dff state_not_waiting_result(.d(rst ? 1'b1 : next_waiting == 2'b00), .q(not_waiting), .wen(~stall), .clk(clk), .rst(1'b0));
    dff state_waiting_result    (.d(rst ? 1'b0 : next_waiting == 2'b01), .q(waiting_b),   .wen(~stall), .clk(clk), .rst(1'b0));
    dff state_waiting_result_br (.d(rst ? 1'b0 : next_waiting == 2'b10), .q(waiting_br),  .wen(~stall), .clk(clk), .rst(1'b0));

    assign offset = instIn[8:0];
    CLAdder16 adder0(.A(pcIn+2),
                   .B({ {6{offset[8]}} , offset , 1'b0 }),
                   .Sum(branchTarget));

    assign next_waiting = mispredicted             ? 2'b00 :
                          instIn[15:12] == 4'b1100 ? 2'b01 :
                          instIn[15:12] == 4'b1101 ? 2'b10 :
                           /* else */                2'b00 ;
    assign mispredicted = (waiting_b & (
        (~prev_t[1] & taken) |
        (prev_t[1]   & ~taken)
    )) | (waiting_br & taken);

    assign predictPcOut = (instIn[15:12] == 4'b1100 & (strong_t | weak_t)) ? branchTarget : pcIn+2;
    assign current_t = strong_nt ? 2'b00 : weak_nt ? 2'b01 : weak_t ? 2'b10 : strong_t ? 2'b11 : 2'b00;
    assign next_t = waiting_b ? (
            taken ? (
                strong_nt ? 2'b01 :
                weak_nt   ? 2'b10 :
                weak_t    ? 2'b11 :
                strong_t  ? 2'b11 : current_t
            ) : (
                strong_nt ? 2'b00 :
                weak_nt   ? 2'b00 :
                weak_t    ? 2'b01 :
                strong_t  ? 2'b10 : current_t
            )
        ) : current_t;
endmodule