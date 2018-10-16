module ControlUnit(opcode, HLT, PCwe, RFwe, MemWE, FLAGwe, NeedBranch, ALU2Src, A2Src, DwMUX);
    input[3:0] opcode;
    output HLT, PCwe, RFwe, MemWE, NeedBranch, ALU2Src, A2Src;
    output[2:0] FLAGwe; // {Z,V,N}
    output[1:0] DwMUX;

    assign HLT = opcode == 4'b1111;
    assign PCwe = ~HLT;
    assign RFwe = (opcode!=4'b1001) & (opcode!=4'b1100) & (opcode!=4'b1101) & (opcode!=4'b1111);
    assign MemWE = opcode == 4'b1001;
    assign FLAGwe = (opcode[3:1]==3'b000) ? 3'b111 :
                    (opcode==4'b0010) | (opcode==4'b0100) | (opcode==4'b0101) | (opcode==4'b0110) ? 3'b100 : 3'b000;
    assign NeedBranch = opcode[3:1] == 3'b110;
    assign ALU2Src = (opcode==4'b0100) | (opcode==4'b0101) | (opcode==4'b0110);
    assign A2Src = opcode[3];
    assign DwMUX = (opcode==4'b1000) ? 2'b01 :
                   (opcode==4'b1110) ? 2'b11 :
                   (opcode[3:1]==3'b101) ? 2'b10 : 2'b00;
endmodule
