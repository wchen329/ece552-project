/* Testbench for 16-bit adder, subtractor
 * Somewhat short one, tests notable boundary cases.
 * All done via black box testing.
 *
 * wchen329@wisc.edu
 */
module addsub_16bit_cla_testbench_boundary();

	reg [3:0] count;
	reg [15:0] A, B;
	reg clock, Sub;
	wire [15:0] Sum;
	wire Ovfl;

	always #50 assign clock = ~clock;

	addsub_16bit_cla DUT(Sum, Ovfl, A, B, Sub);	

always@(posedge clock) begin

	// Test -2^15 - (-2^15) == 0
	if(count == 1) begin
		assign A = 16'b1000000000000000;
		assign B = 16'b1000000000000000;
		assign Sub = 1'b1;
	end

	// Test -8 - positive == -8 (saturation)
	if(count == 2) begin
		assign A = 16'b1000000000000000;
		assign B = 16'b0101000000000000;
		assign Sub = 1'b1;
	end

	// Sanity test. Non edge case work? 2 + 3 == 5
	if(count == 3) begin
		assign A = 16'b0000000000000010;
		assign B = 16'b0000000000000011;
		assign Sub = 1'b0;
	end

	// Test -2^15 + -2^15 == -2^15 (saturation)
	if(count == 4) begin
		assign A = 16'b1000000000000000;
		assign B = 16'b1000000000000000;
		assign Sub = 1'b0;
	end

	// Test positive - (-2^15) == 2^15 - 1 (saturation)
	if(count == 5) begin
		assign A = 16'b0011111111111111;
		assign B = 16'b1000000000000000;
		assign Sub = 1'b1;
	end

	// Test 2^15 - 1 + 1 = 2^15 - 1 (saturation)
	if(count == 6) begin
		assign A = 16'b0111111111111111;
		assign B = 16'b0000000000000001;
		assign Sub = 0'b0;
	end

	// Test 2^15 - 2 + 1 = 2^15 - 1 (no saturation)
	if(count == 7) begin
		assign A = 16'b0111111111111110;
		assign B = 16'b0000000000000001;
		assign Sub = 0'b0;
	end
end

// Probe
always@(negedge clock) begin
	if(count == 1) begin
		if(Sum != 16'b0000000000000000 || Ovfl != 0) begin
			$display("Error! Test 1 failed!");
			$stop;
		end
	end

	if(count == 2) begin
		if(Sum != 16'b1000000000000000 || Ovfl != 1) begin
			$display("Error! Test 2 failed!");
			$stop;
		end
	end

	if(count == 3) begin
		if(Sum != 16'b0000000000000101 || Ovfl != 0) begin
			$display("Error! Test 3 failed!");
			$stop;
		end
	end

	if(count == 4) begin
		if(Sum != 16'b1000000000000000 || Ovfl != 1) begin
			$display("Error! Test 4 failed!");
			$stop;
		end
	end

	if(count == 5) begin
		if(Sum != 16'b0111111111111111 || Ovfl != 1) begin
			$display("Error! Test 5 failed!");
			$stop;
		end
	end

	if(count == 6) begin
		if(Sum != 16'b0111111111111111 || Ovfl != 1) begin
			$display("Error! Test 6 failed!");
			$stop;
		end
	end

	if(count == 7) begin
		if(Sum != 16'b0111111111111111 || Ovfl != 0) begin
			$display("Error! Test 7 failed!");
			$stop;
		end
	end

	assign count = count + 1;
end

initial begin
	assign clock = 0;
	assign A = 0;
	assign B = 0;
	assign Sub = 0;
	assign count = 0;

	#5000 begin
		$display("Test finished. If no errors were printed, then tests passed successfully.");
		$stop;
	end
end

endmodule