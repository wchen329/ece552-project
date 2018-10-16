/* Testbench for 16-bit adder, subtractor
 * Shorter than the exhaustive one, based on random numbers
 *
 * wchen329@wisc.edu
 */
module addsub_16bit_cla_testbench_random();

	reg [15:0] A, B, sub_ref, add_ref, sub_inter, add_inter, neg_B;
	reg clock, Sub;
	wire [15:0] Sum;
	wire Ovfl;

	always #1 assign clock = ~clock;

	addsub_16bit_cla DUT(Sum, Ovfl, A, B, Sub);	

always@(posedge clock) begin
	assign Sub = Sub + $random;
	assign A = A + $random;
	assign B = B + $random;
end

// Probe
always@(negedge clock) begin
	assign sub_inter = A - B;
	assign add_inter = A + B;
	assign neg_B = -B;

	// Construct correct values

	/* Adder Values
	 *
	 */
	if(A[15] == B[15] && add_inter[15] != A[15]) begin

		// Check for Overflow flag being set
		if(Ovfl == 0 && Sub == 0) begin
			$display("Overflow occurred, but corresponding flag not set");
			$stop;	
		end

		// Case 1, add two positive numbers and saturate at most positive
		if(A[15] == 0) begin 
			assign add_ref = 16'b0111111111111111;
		end

		// Case 2, add two negative numbers and saturate at most negative
		if(A[15] != 0) begin
			assign add_ref = 16'b1000000000000000;
		end
	end

	else begin
		assign add_ref = add_inter;

		if(Ovfl == 1 && Sub == 0) begin
			$display("Overflow did not occur, but corresponding flag set");
			$stop;
		end

	end

	/* Subtractor Values
	 *
	 */
	if(A[15] == neg_B[15] && sub_inter[15] != A[15]) begin

		if(Ovfl == 0 && Sub == 1) begin
			$display("Overflow occurred, but corresponding flag not set");
			$stop;
		end

		// Case 1, add two positive numbers and saturate at most positive
		if(A[15] == 0) begin 
			assign sub_ref = 16'b0111111111111111;
		end

		// Case 2, add two negative numbers and saturate at most negative
		if(A[15] != 0) begin
			assign sub_ref = 16'b1000000000000000;

		end
	end

	else begin
		assign sub_ref = sub_inter;

		if(Ovfl == 1 && Sub == 1) begin
			$display("Overflow did not occur, but corresponding flag set");
			$stop;
		end
	end

	// Probe
	if(Sub != 0) begin
		if(sub_ref != Sum) begin
			$display("An error has occurred, subtraction mismatch");
			$stop;
		end
	end

	else begin
		if(add_ref != Sum) begin
			$display("An error has occurred, addition mismatch");
			$stop;
		end
	end
end

initial begin
	assign clock = 0;
	assign A = 0;
	assign B = 0;
	assign Sub = 0;
	assign sub_ref = 0;
	assign add_ref = 0;
	assign sub_inter = 0;
	assign add_inter = 0;
	assign neg_B = 0;

	#2000000 begin
		$display("Test finished. If no errors were printed, then tests passed successfully.");
		$stop;
	end
end

endmodule
