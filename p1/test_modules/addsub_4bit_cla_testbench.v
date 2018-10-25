/* A testbench for the four bit adder and subtractor.
 * Fully exhaustive, for all 512 cases.
 *
 * wchen329@wisc.edu
 */
module addsub_4bit_cla_testbench();

	reg [3:0] A, B;
	reg [5:0] A_ext, B_ext, sub_inter, add_inter, add_ref, sub_ref, Sum_sign_ext,
			add_gt_7, add_lt_neg_8, sub_gt_7, sub_lt_neg_8;
	reg clock, Sub;	
	wire [3:0] Sum;

	always #50 assign clock = ~clock;

	addsub_4bit_cla DUT(Sum, A, B, Sub);	

always@(posedge clock) begin
	assign {Sub, A, B} = {Sub, A, B} + 1;
end

// Probe
always@(negedge clock) begin
	assign A_ext = { {2{A[3]}}, A};
	assign B_ext = { {2{B[3]}}, B};
	assign sub_inter = A_ext - B_ext;
	assign add_inter = A_ext + B_ext;
	assign Sum_sign_ext = {{2{Sum[3]}}, Sum};

	// Comparison values
	assign add_gt_7 = add_inter - 6'b000111; 
	assign add_lt_neg_8 = add_inter - 6'b111000;
	assign sub_gt_7 = sub_inter - 6'b000111;
	assign sub_lt_neg_8 = sub_inter - 6'b111000;

	// Construct correct values

	/* Adder Values
	 * add_inter > 7 || add_inter < -8
	 */
	if((add_gt_7[5] == 0 && add_gt_7 != 0 ) || add_lt_neg_8[5] == 1) begin

		// Case 1, add two positive numbers and saturate at most positive
		if(A[3] == 0) begin 
			assign add_ref = 6'b000111;
		end

		// Case 2, add two negative numbers and saturate at most negative
		if(A[3] != 0) begin
			assign add_ref = 6'b111000;
		end
	end

	else begin
		assign add_ref = add_inter;
	end

	/* Subtractor Values
	 * sub_inter > 7 || sub_inter < -8
	 */
	if((sub_gt_7[5] == 0 && add_gt_7 != 0 ) || sub_lt_neg_8[5] == 1) begin

		// Case 1, add two positive numbers and saturate at most positive
		if(A[3] == 0) begin 
			assign sub_ref = 6'b000111;
		end

		// Case 2, add two negative numbers and saturate at most negative
		if(A[3] != 0) begin
			assign sub_ref = 6'b111000;
	
		end
	end

	else begin
		assign sub_ref = sub_inter;
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

	#51200 begin
		$display("Test finished. If no errors were printed, then tests passed successfully.");
		$stop;
	end
end

endmodule