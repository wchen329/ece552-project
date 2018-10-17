/* A simple exhaustive testbench for the shifter. This one only tests SLL and SRA.
 * ROR has its own testbench.
 *
 * Runs for all 2^21 cases so exhaustive indeed.
 *
 * wchen329@wisc.edu
 */
module Shifter_3_1_testbench();

	reg clock;
	reg [1:0] shift_mode;
	reg [15:0] A;
	reg [3:0] shift_arg;

	wire [15:0] test_output;
	
	Shifter_3_1 DUT(test_output, A, shift_arg, shift_mode);

	always #100 assign clock = ~clock;

	// Assign new test values
	always @(posedge clock) begin
		assign {shift_mode, shift_arg, A} = {shift_mode, shift_arg, A} + 1;
	end

	// Probe and produce errors if needed
	always @(negedge clock) begin
		
		// Test correct shift left
		if(shift_mode == 0) begin
			if(test_output != (A << shift_arg)) begin
				$display("An error occurred: Left shift test failed.");
				$stop;
			end
		end
		
		// Test correct right shift
		if(shift_mode == 1) begin
			if(test_output != ((A >> shift_arg) | -(A[15] << (15 - shift_arg)))) begin
				$display("An error occurred: Right shift test failed.");
				$stop;
			end
		end
	end

	initial begin
		assign A = 0;
		assign clock = 0;
		assign shift_mode = 0;
		assign shift_arg = 0;
		#419430400 begin
			 $display("Test completed successfully. If this is the first time the test has stopped automatically then it has completed without errors");
			 $stop;
			 $finish;
		end
	end

endmodule