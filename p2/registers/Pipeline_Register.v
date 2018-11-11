/* A Pipeline Register. Really a mini register file.
 * 
 * This pipeline register stores information related to the state of the instruction of the current stage.
 * State information includes: Control Signals, Register read values, ONE result register for intermediate values in operations or stores
 *
 * wchen329@wisc.edu
 */
module Pipeline_Register(clk, rst, WE, ALU_Op_next, ALU_Src_next, Reg_Write_next, Mem_Read_next, Mem_Write_next, Opcode, register_bl_1_next, register_bl_2_next, result_next,	// next state
				ALU_Op, ALU_Src, Reg_Write, Mem_Read, Mem_Write, Opcode_next, register_bl_1, register_bl_2, result);						// current state 

	// Inputs
	input clk; // Clock signal of the processor
	input WE; // Write Enable the register, reset has precedence, active high
	input rst; // input active high reset signal, asserting basically inserts a no-op at the current stage
	input [2:0] ALU_Op_next; // ALU Opcode
	input Reg_Write_next, ALU_Src_next; // Writing to register file control signals 
	input Mem_Read_next, Mem_Write_next; // Memory control signals 
	input [5:0] Opcode_next; // full opcode
	input [15:0] register_bl_1_next, register_bl_2_next, result_next; // Bitlines retrieved during decode stage, result is the "free" intermediate register 

	// Outputs
	output [2:0] ALU_Op;
	output Reg_Write, ALU_Src;
	output Mem_Read, Mem_Write;
	output [5:0] Opcode;
	output [15:0] register_bl_1, register_bl_2, result;

	// 1 bit signals
	BitCell REG_WRITE (.clk(clk), .rst(rst), .D(Reg_Write_next), .WriteEnable(WE), .ReadEnable1(1), .ReadEnable2(0), .Bitline1(Reg_Write));
	BitCell MEM_READ (.clk(clk), .rst(rst), .D(Mem_Read_next), .WriteEnable(WE), .ReadEnable1(1), .ReadEnable2(0), .Bitline1(Mem_Read));
	BitCell MEM_WRITE (.clk(clk), .rst(rst), .D(Mem_Write_next), .WriteEnable(WE), .ReadEnable1(1), .ReadEnable2(0), .Bitline1(Mem_Write)); 
	BitCell ALU_SRC (.clk(clk), .rst(rst), .D(ALU_Src_next), .WriteEnable(WE), .ReadEnable1(1), .ReadEnable2(0), .Bitline1(ALU_Src)); 

	// 3 bit signal
	Register_3bit ALU_OP(.clk(clk), .rst(rst), .D(ALU_Op_next), .WriteReg(WE), .ReadEnable1(1), .ReadEnable2(0), .Bitline1(ALU_Op));
	
	// 6 bit signal	
	Register_6bit OPCODE(.clk(clk), .rst(rst), .D(Opcode_next), .WriteReg(WE), .ReadEnable1(1), .ReadEnable2(0), .Bitline1(Opcode));

	// 16 bit signals
	Register BL_1(.clk(clk), .rst(rst), .D(register_bl_1_next), .WriteReg(WE), .ReadEnable1(1), .ReadEnable2(0), .Bitline1(register_bl_1));
	Register BL_2(.clk(clk), .rst(rst), .D(register_bl_2_next), .WriteReg(WE), .ReadEnable1(1), .ReadEnable2(0), .Bitline1(register_bl_2));
	Register RESULT(.clk(clk), .rst(rst), .D(result_next), .WriteReg(WE), .ReadEnable1(1), .ReadEnable2(0), .Bitline1(result));


endmodule
