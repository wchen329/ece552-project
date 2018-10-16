/* Testbench for ALU.
 * Checks validity of associated arithmetic operations.
 *
 * Tests a million cases.
 *
 * wchen329@wisc.edu
 */
module ALU_no_check_testbench();

	reg clock;

	always #1 assign clock = ~clock;

	// Stimuli
	reg [15:0] A, B;
	reg [2:0] op;
	wire [15:0] result;
	wire [2:0] flags;
	
	// Reference values for each ALU operation
	wire [15:0] ref_add, ref_sub, ref_xor, ref_red, ref_sll, ref_sra, ref_ror, ref_paddsb;
	reg [15:0] ref_op;
	wire overflow;

	// Reference modules
	addsub_16bit_cla ADD(ref_add, overflow, A, B, 0);
	addsub_16bit_cla SUB(ref_sub, overflow, A, B, 1);
	xor_16bit XOR(ref_xor, A, B);

	ALU_no_check ALU(A, B, op, result, flags);

	// Assign new test values
	always @(posedge clock) begin
		assign A = A * $random + $random;
		assign B = B * $random + $random;
		assign op = op * $random + $random;
	end

	// Probe
	always @(negedge clock) begin

		if (op == 0) begin
			if(ref_add != result ) begin

				$display("Error detected. Incorrect addition.");
				$stop;

			end
		end		

		if(op == 1) begin
			if(ref_sub != result) begin

				$display("Error detected. Incorrect subtraction.");
				$stop;
			end
		end

		
		if(op == 2) begin
			if(ref_xor != result) begin

				$display("Error detected. Incorrect XOR.");
				$stop;
			end
		end

			
		if(op == 3) begin
			if(ref_red != result) begin

				$display("Error detected. Incorrect RED.");
				$stop;
			end
		end


		if(op == 4) begin
			if(ref_sll != result) begin

				$display("Error detected. Incorrect SLL.");
				$stop;
			end
		end

		if(op == 5) begin
			if(ref_sra != result) begin

				$display("Error detected. Incorrect SRA.");
				$stop;
			end
		end

		if(op == 6) begin
			if(ref_ror != result) begin

				$display("Error detected. Incorrect ROR.");
				$stop;
			end
		end

		if(op == 7) begin
			if(ref_paddsb != result) begin

				$display("Error detected. Incorrect PADDSB.");
				$stop;
			end
		end

		assign ref_op = op == 0 ? ref_add :
				op == 1 ? ref_sub :
				op == 2 ? ref_xor :
				op == 3 ? ref_red :
				op == 4 ? ref_sll :
				op == 5 ? ref_sra :
				op == 6 ? ref_ror :
				op == 7 ? ref_paddsb : 0;

		// Test Flags
		if(op != 7) begin
			if ( ref_op != 0 && flags[2] == 1) begin
				$display("Error detected. Zero flag set when not zero");
				$stop;
			end  

			if ( ref_op == 0 && flags[2] == 0) begin
				$display("Error detected. Zero flags not set when zero");
				$stop;
			end
		end

		if(op == 0 || op == 1) begin
			if (ref_op[15] == 1 && flags[0] != 1) begin
				$display("Error detected. Sign flag not set when negative.");
				$stop;
			end

			if (ref_op[15] == 0 && flags[0] != 0) begin
				$display("Error detected. Sign flag set when not negative.");
				$stop;
			end

			if(flags[1] != overflow) begin
				$display("Error detected. Overflow flag is incorrect.");
				$stop;
			end
		end
	end

	initial begin
		assign A = 0;
		assign B = 0;
		assign op = 0;
		assign clock = 0;

		#2000000 begin
			$display("Test completed. If no errors were printed, then the test was successful");
			$stop;
		end

	end

endmodule
