module ForwardToALU(aluSrcSel,aluSrc, exDst, memDst,willExWrite, willMemWrite); // two instences is required for two alu input
    output[1:0] aluSrcSel; // 0=no forwarding; 1=from EX; 2=from MEM; 3=unused
    input[3:0] aluSrc, exDst, memDst;
    input willExWrite, willMemWrite;
    wire forwardFromEx, forwardFromMem;

    assign forwardFromEx  = willExWrite  & (exDst==aluSrc);
    assign forwardFromMem = willMemWrite & (memDst==aluSrc);
    assign aluSrcSel = aluSrc==4'b0   ? 2'b00 :
                       forwardFromEx  ? 2'b01 :
                       forwardFromMem ? 2'b10 :
                       /* else */       2'b00 ;
endmodule

module ForwardToMem(memSrcSel,memSrc, wbDst,willWrite);
    output memSrcSel; // 0=no forwarding; 1=from MEM/WB
    input[3:0] memSrc, wbDst;
    input willWrite; // if RF will be written in WB stage

    assign memSrcSel = (memSrc != 4'b0)  &
                       (memSrc == wbDst) &
                       (willWrite);
endmodule

module ForwardToBranchRegister(brSrcSel,brSrc, aluDst, exDst,willAluWrite, willExWrite);
    output[1:0] brSrcSel; // 0=no forwarding; 1=from ALU(ID/EX); 2=from EX/MEM; 3=unused
    input [3:0] brSrc, aluDst, exDst;
    input willAluWrite, willExWrite;

    wire fromAlu, fromEx, fromMem;
    assign fromAlu = (brSrc == aluDst) & willAluWrite;
    assign fromEx  = (brSrc == exDst)  & willExWrite;
    assign brSrcSel = brSrc == 4'b0 ? 2'b00 :
                      fromAlu       ? 2'b01 :
                      fromEx        ? 2'b10 :
                      /* else */      2'b00 ;
endmodule