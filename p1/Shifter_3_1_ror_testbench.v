/* A simple exhaustive testbench for the shifter. This one for ROR.
 *
 * Runs for all 2^20 cases so exhaustive indeed.
 *
 * wchen329@wisc.edu
 */
module Shifter_3_1_ror_testbench();

	reg clock;
	reg [15:0] A;
	reg [3:0] shift_arg;
	reg [31:0] working;
	reg [15:0] reference_output;

	wire [15:0] test_output;
	

	Shifter_3_1 DUT(test_output, A, shift_arg, 3'b110);

	always #100 assign clock = ~clock;

	// Assign new test values
	always @(posedge clock) begin
		assign {shift_arg, A} = {shift_arg, A} + 1;
		assign working = {A, {16{1'b0}}};
		assign working = (working >> shift_arg);
		assign reference_output = working[15:0] | working[31:16];
	end

	// Probe and produce errors if needed
	always @(negedge clock) begin
		if(reference_output != test_output) begin
			$display("Error detected. ROR mismatch");
			$stop;
		end
	end

	initial begin
		assign A = 0;
		assign clock = 0;
		assign shift_arg = 0;
		assign working = 0;
		assign reference_output = 0;
		#209715200 begin
			 $display("Test completed successfully. If this is the first time the test has stopped automatically then it has completed without errors");
			 $stop;
			 $finish;
		end
	end

endmodule