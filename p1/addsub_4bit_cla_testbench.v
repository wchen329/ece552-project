/* A testbench for the four bit adder and subtractor.
 * Fully exhaustive, for all 512 cases.
 *
 * wchen329@wisc.edu
 */
module addsub_4bit_cla_testbench();

	reg [3:0] A, B, sub_ref, add_ref, sub_inter, add_inter, neg_B;
	reg clock, Sub;	
	wire [3:0] Sum;

	always #50 assign clock = ~clock;

	addsub_4bit_cla DUT(Sum, A, B, Sub);	

always@(posedge clock) begin
	assign {Sub, A, B} = {Sub, A, B} + 1;
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
	if(A[3] == B[3] && add_inter[3] != A[3]) begin

		// Case 1, add two positive numbers and saturate at most positive
		if(A[3] == 0) begin 
			assign add_ref = 4'b0111;
		end

		// Case 2, add two negative numbers and saturate at most negative
		if(A[3] != 0) begin
			assign add_ref = 4'b1000;
		end
	end

	else begin
		assign add_ref = add_inter;
	end

	/* Subtractor Values
	 *
	 */
	if(A[3] == neg_B[3] && sub_inter[3] != A[3]) begin

		// Case 1, add two positive numbers and saturate at most positive
		if(A[3] == 0) begin 
			assign sub_ref = 4'b0111;
		end

		// Case 2, add two negative numbers and saturate at most negative
		if(A[3] != 0) begin
			assign sub_ref = 4'b1000;

		end
	end

	else begin
		assign sub_ref = sub_inter;
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

	#51200 begin
		$display("Test finished. If no errors were printed, then tests passed successfully.");
		$stop;
	end
end

endmodule