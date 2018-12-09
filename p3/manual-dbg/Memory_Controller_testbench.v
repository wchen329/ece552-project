/* A testbench for the memory controller.
 *
 * wchen329@wisc.edu
 */
module Memory_Controller_testbench();

	reg clk, rst, r_enabled;
	reg [15:0] addr_0, addr_1;
	reg [31:0] cycle_count;
	reg [15:0] Data_In;

	wire [1:0] miss;
	wire [15:0] i_data_out, d_data_out;

	always #50 assign clk = ~clk;

	// Increase cycle count every posedge
	always @(posedge clk) begin
		assign cycle_count = cycle_count + 1;
	end

	// Declare DUT
	Memory_Controller DUT(.clk(clk), .rst(rst), .if_addr(addr_0), .if_we(1'b0), .dm_we(1'b0), .d_enable(r_enabled), .dm_addr(addr_1),
	.if_data_out(i_data_out), .dm_data_out(d_data_out), .if_data_in(Data_In), .dm_data_in(Data_In), .if_miss(miss[0]), .dm_miss(miss[1]));

	initial begin
		assign r_enabled = 0;
		assign clk = 0;
		assign cycle_count = 0;
		assign rst = 1;
		assign addr_0 = 5235;
		assign addr_1 = 0;
		assign Data_In = 12;
		
	end

endmodule
