module NeedBranch(C, F, Branch);
    // module Check_Branch.v by Huimin
    input [2:0] C; //3-bit condition
    input [2:0] F; //3-bit flag {Z,V,N}
    output Branch;

    wire EQ, NEQ, GT, LT, GTE, LTE, OVFL, UNCOND;

    assign NEQ = ~F[2] & ~C[2] & ~C[1] & ~C[0];
    assign EQ = F[2] & ~C[2] & ~C[1] & C[0];
    assign GT = ~F[2] & ~F[0] & ~C[2] & C[1] & ~C[0];
    assign LT = F[0] & ~C[2] & C[1] & C[0];
    assign GTE = (F[2] | (~F[2] & ~F[0])) & C[2] & ~C[1] & ~C[0];
    assign LTE = (F[2] | F[0]) & C[2] & ~C[1] & C[0];
    assign OVFL = F[1] & C[2] & C[1] & ~C[0];
    assign UNCOND = C[2] & C[1] & C[0]; //ccc = 111

    assign Branch = NEQ | EQ | GT | LT | GTE | LTE | OVFL | UNCOND;
endmodule


module PC_Control(opcode, condition, flagZVN, offset, target_reg, PC_in, taken, PC_out);
    // module by Zhenghao
    input [3:0] opcode;
    input [2:0] condition; // used only if opcode is B or BR
    input [2:0] flagZVN; // from FLAG register {Z,V,N}
    input [8:0] offset; // used only if is opcode is B
    input [15:0] target_reg; // used only if opcode id BR
    input [15:0] PC_in;
    output taken; // meaningful only if opcode is B or BR
    output[15:0] PC_out; // PC_in+2 if not taken else branch_target

    wire [15:0] target_plus2, target_offset;

    NeedBranch nb0(.C(condition), .F(flagZVN), .Branch(taken));
    CLAdder16 add0(.A(PC_in), .B(16'h0002), .Sum(target_plus2));
    CLAdder16 add1(.A(target_plus2),
                   .B({ {6{offset[8]}} , offset , 1'b0 }),
                   .Sum(target_offset));

    assign PC_out = opcode[3:1] != 3'b110 ? target_plus2  :
                    taken == 1'b0         ? target_plus2  :
                    opcode[0] == 1'b0     ? target_offset :
                                            target_reg    ;
endmodule
