/* A testbench for the cache toplevel.
 *
 * wchen329@wisc.edu
 */
module Cache_Toplevel_testbench();

	reg clk, rst, r_enabled;
	reg [15:0] Address_Oper;
	reg [1:0] cacheop;
	reg [31:0] cycle_count;
	reg [15:0] Data_In;

	wire miss_occurred;
	wire [15:0] Data_Out;

	always #50 assign clk = ~clk;

	// Increase cycle count every posedge
	always @(posedge clk) begin
		assign cycle_count = cycle_count + 1;
	end

	// Declar DUT
	Cache_Toplevel DUT(.clk(clk), .rst(rst), .r_enabled(r_enabled), .Address_Oper(Address_Oper), .cacheop(cacheop), .Data_In(Data_In), .Data_Out(Data_Out), .miss_occurred(miss_occurred));

	initial begin
		assign r_enabled = 0;
		assign clk = 0;
		assign cycle_count = 0;
		assign rst = 1;
		assign Address_Oper = 5235;
		assign Data_In = 12;
		assign cacheop = 0;
	end

endmodule