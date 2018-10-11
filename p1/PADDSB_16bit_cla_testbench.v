/* A testbench for the parallel subword adder.
 *
 * wchen329@wisc.edu
 */
module PADDSB_16bit_cla_testbench();

	reg [15:0] A, B;
	reg [3:0] add_ref_0, add_inter_0,
			add_ref_1, add_inter_1,
			add_ref_2, add_inter_2,
			add_ref_3, add_inter_3;
	reg clock;
	wire [15:0] Sum;
	reg [3:0] Sum_0, Sum_1, Sum_2, Sum_3;

	always #50 assign clock = ~clock;

	PADDSB_16bit_cla DUT(Sum, A, B);	

always@(posedge clock) begin
	assign A = A + $random;
	assign B = B + $random;
end

// Probe
always@(negedge clock) begin
	assign add_inter_0 = A[3:0] + B[3:0];
	assign add_inter_1 = A[7:4] + B[7:4];
	assign add_inter_2 = A[11:8] + B[11:8];
	assign add_inter_3 = A[15:12] + B[15:12];
	assign Sum_0 = Sum[3:0];
	assign Sum_1 = Sum[7:4];
	assign Sum_2 = Sum[11:8];
	assign Sum_3 = Sum[15:12];

	// Construct correct values

	/* Adder Values
	 * for word 3...0
	 */
	if(A[3] == B[3] && add_inter_0[3] != A[3]) begin

		// Case 1, add two positive numbers and saturate at most positive
		if(A[3] == 0) begin 
			assign add_ref_0 = 4'b0111;
		end

		// Case 2, add two negative numbers and saturate at most negative
		if(A[3] != 0) begin
			assign add_ref_0 = 4'b1000;
		end
	end

	else begin
		assign add_ref_0 = add_inter_0;
	end

	/* Adder Values
	 * for word 7...4
	 */
	if(A[7] == B[7] && add_inter_1[3] != A[7]) begin

		// Case 1, add two positive numbers and saturate at most positive
		if(A[7] == 0) begin 
			assign add_ref_1 = 4'b0111;
		end

		// Case 2, add two negative numbers and saturate at most negative
		if(A[7] != 0) begin
			assign add_ref_1 = 4'b1000;
		end
	end

	else begin
		assign add_ref_1 = add_inter_1;
	end

	/* Adder Values
	 * for word 11...8
	 */
	if(A[11] == B[11] && add_inter_2[3] != A[11]) begin

		// Case 1, add two positive numbers and saturate at most positive
		if(A[11] == 0) begin 
			assign add_ref_2 = 4'b0111;
		end

		// Case 2, add two negative numbers and saturate at most negative
		if(A[11] != 0) begin
			assign add_ref_2 = 4'b1000;
		end
	end

	else begin
		assign add_ref_2 = add_inter_2;
	end

	/* Adder Values
	 * for word 15...12
	 */
	if(A[15] == B[15] && add_inter_3[3] != A[15]) begin

		// Case 1, add two positive numbers and saturate at most positive
		if(A[15] == 0) begin 
			assign add_ref_3 = 4'b0111;
		end

		// Case 2, add two negative numbers and saturate at most negative
		if(A[15] != 0) begin
			assign add_ref_3 = 4'b1000;
		end
	end


	else begin
		assign add_ref_3 = add_inter_3;
	end

	// Probe
	if(add_ref_0 != Sum[3:0] || add_ref_1 != Sum[7:4] || add_ref_2 != Sum[11:8] || add_ref_3 != Sum[15:12]) begin
		$display("An error has occurred, addition mismatch");
		$stop;
	end
end

initial begin
	assign clock = 0;
	assign A = 0;
	assign B = 0;

	#6553600 begin
		$display("Test finished. If no errors were printed, then tests passed successfully.");
		$stop;
	end
end

endmodule