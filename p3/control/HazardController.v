module HazardController(stall,aluSrc1, aluSrc2, brSrc, lwDst,willWrite, isBr, isUnconditional);
    output stall;
    input [3:0] aluSrc1, aluSrc2, brSrc, lwDst; // toplevel need to set these to 0 if unused
    input willWrite, isBr, isUnconditional;

    wire lwExStall, lwBrStall;
    assign lwExStall = willWrite & (lwDst!=4'b0) & (
                        (aluSrc1==lwDst) |
                        (aluSrc2==lwDst)
                    );
    assign lwBrStall = willWrite & (lwDst!=4'b0) & isBr & ~isUnconditional & (lwDst==brSrc);

    assign stall = lwExStall | lwBrStall;
endmodule
