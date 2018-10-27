/* Testbench for 16-bit adder, subtractor
 * Shorter than the exhaustive one, based on random numbers
 *
 * wchen329@wisc.edu
 */
module addsub_16bit_cla_testbench_random();

	reg [15:0] A, B;
	reg [17:0] sub_ref, add_ref, sub_inter, add_inter, A_ext, B_ext, Sum_sign_ext,
			add_gt_max, add_lt_min, sub_gt_max, sub_lt_min; 
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
	assign A_ext = { {2{A[15]}}, A};
	assign B_ext = { {2{B[15]}}, B};
	assign Sum_sign_ext = { {2{Sum[15]}}, Sum};
	assign sub_inter = A_ext - B_ext;
	assign add_inter = A_ext + B_ext;

	// Comparison values
	assign add_gt_max = add_inter - 18'b000111111111111111; 
	assign add_lt_min = add_inter - 18'b111000000000000000;
	assign sub_gt_max = sub_inter - 18'b000111111111111111;
	assign sub_lt_min = sub_inter - 18'b111000000000000000;

	// Construct correct values

	/* Adder Values
	 *
	 */
	if((add_gt_max[17] == 0 && add_gt_max != 0) || add_lt_min[17] == 1) begin

		// Check for Overflow flag being set
		if(Ovfl == 0 && Sub == 0) begin
			$display("Overflow occurred, but corresponding flag not set");
			$stop;	
		end

		// Case 1, add two positive numbers and saturate at most positive
		if(A[15] == 0) begin 
			assign add_ref = 18'b000111111111111111;
		end

		// Case 2, add two negative numbers and saturate at most negative
		if(A[15] != 0) begin
			assign add_ref = 18'b111000000000000000;
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
	if((sub_gt_max[17] == 0 && sub_gt_max != 0) || sub_lt_min[17] == 1) begin

		if(Ovfl == 0 && Sub == 1) begin
			$display("Overflow occurred, but corresponding flag not set");
			$stop;
		end

		// Case 1, add two positive numbers and saturate at most positive
		if(A[15] == 0) begin 
			assign sub_ref = 18'b000111111111111111;
		end

		// Case 2, add two negative numbers and saturate at most negative
		if(A[15] != 0) begin
			assign sub_ref = 18'b111000000000000000;

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
		if(sub_ref != Sum_sign_ext) begin
			$display("An error has occurred, subtraction mismatch");
			$stop;
		end
	end

	else begin
		if(add_ref != Sum_sign_ext) begin
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

	#2000000 begin
		$display("Test finished. If no errors were printed, then tests passed successfully.");
		$stop;
	end
end

endmodule
