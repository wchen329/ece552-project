module flagZVN_forwarding_mux (ALU_flagZVN, IDEX_flagZVN_we, EXMEM_flagZVN, EXMEM_flagZVN_we, FR_flagZVN, flagZVN_out);
    /* construct the correct FLAG={Z,V,N} based on all pipeline registers & flag register */
    input[2:0] ALU_flagZVN, IDEX_flagZVN_we;    // flag from ALU, i.e. previous instruction
    input[2:0] EXMEM_flagZVN, EXMEM_flagZVN_we; // flag from EX stage, i.e. previous of previous instruction
    input[2:0] FR_flagZVN;                      // FlagRegister. i.e. even earlier instructions.
                                                // Note: FR should take care of passthrough so MEM/WB.flagZVN can be passed correctly.
    output[2:0] flagZVN_out;                    // constructed flag to be fed into PC_Control

    wire z1,v1,n1,z2,v2,n2,z3,v3,n3;
    wire ze1,ve1,ne1,ze2,ve2,ne2;
    assign {z1,v1,n1} = ALU_flagZVN;
    assign {z2,v2,n2} = EXMEM_flagZVN;
    assign {z3,v3,n3} = FR_flagZVN;
    assign {ze1,ve1,ne1} = IDEX_flagZVN_we;
    assign {ze2,ve2,ne2} = EXMEM_flagZVN_we;
    assign flagZVN_out[2] = ze1?z1 :ze2?z2 :z3;
    assign flagZVN_out[1] = ve1?v1 :ve2?v2 :v3;
    assign flagZVN_out[0] = ne1?n1 :ne2?n2 :n3;
endmodule
