/* Simple test bench for 4-bit CLA
 * Full exhaustive, goes through all 512 cases possible for this adder.
 *
 * wchen329@wisc.edu
 */
module adder_4bit_cla_simple_testbench();

reg [3:0] A, B, reference_Sum, null_sum_1, null_sum_2;
reg Cin, Propagate_ref, Generate_ref;
reg clock;
wire[3:0] Sum;
wire Propagate, Generate;

adder_4bit_cla_simple ADDER(Propagate, Generate, Sum, A, B, Cin);

always #50 assign clock = ~clock;

always @(posedge clock) begin
	assign {A, B, Cin} = {A, B, Cin} + 1;
end

always @(negedge clock) begin
	assign reference_Sum = A + B + Cin;
	assign {Generate_ref, null_sum_1} = A + B;
	assign {Propagate_ref, null_sum_2} = A + B + 1;

	if(reference_Sum != Sum) begin
		$display("Error detected, sum is incorrect.");
		$stop;
	end

	if(Propagate_ref != Propagate) begin
		$display("Error detected, propagate is incorrect.");
		$stop;
	end

	if(Generate_ref != Generate) begin
		$display("Error detected, generate is incorrect.");
		$stop;
	end
end

initial begin
	assign clock = 0;
	assign A = 0;
	assign B = 0;
	assign Cin = 0;
	assign null_sum_1 = 0;
	assign null_sum_2 = 0;
	assign Propagate_ref = 0;
	assign Generate_ref = 0;
	#51200 begin
		$display("Test finished. If no errors were printed, then tests passed successfully.");
		$stop;
	end
end

endmodule