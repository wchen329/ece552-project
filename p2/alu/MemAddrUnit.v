// memAddr = (baseAddr & 0xFFFE) + (signExtended(offset) << 1)
module MemAddrUnit(baseAddr, offset, memAddr);
    input[15:0] baseAddr; // the base address from RF
    input[3:0] offset; // offset from inst[3:0]
    output[15:0] memAddr; // the actual memory address to be accessed

    CLAdder16 adder0(.A(baseAddr & 16'hFFFE), .B({{11{offset[3]}}, offset, 1'b0}), .Sum(memAddr));
endmodule
