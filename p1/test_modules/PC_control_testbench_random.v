/* Testbench for the PC Control.
 * Tests a small set of random branch instructions.
 * Modified from exhaustive testbench. 
 *
 * wchen329@wisc.edu
 */
module PC_control_testbench_random();

	reg clock;
	reg [2:0] C;
	reg [2:0] F;
	reg [8:0] I;
	reg [15:0] PC_In;
	wire [15:0] PC_Out;
	wire Z, V, N;
	always #1 assign clock = ~clock;
	assign Z = F[2];
	assign V = F[1];
	assign N = F[0]; 
	reg [15:0] PC_ref_nott;
	reg [15:0] PC_ref_take;

	PC_control DUT(C, I, F, PC_In, PC_Out);

	// Assign new values at each positive clock edge
	always @(posedge clock) begin
		assign PC_In = PC_In + $random;
		assign {I, C, F} = {I, C, F} + 1;
	end

	// Test values at negative clock edges
	always @(negedge clock) begin
		assign PC_ref_nott = PC_In + 2;
		assign PC_ref_take = PC_In + (I << 1) + 2;

		if(C == 0) begin
			if(Z == 1) begin
				if(PC_Out != PC_ref_nott) begin
					$display("Error detected. CC 0 failure");
					$stop;
				end
			end

			else begin
				if(PC_Out != PC_ref_take) begin
					$display("Error detected. CC 0 failure");
					$stop;
				end
			end
		end

		if(C == 1) begin
			if(Z == 0) begin
				if(PC_Out != PC_ref_nott) begin
					$display("Error detected. CC 1 failure");
					$stop;
				end
			end

			else begin
				if(PC_Out != PC_ref_take) begin
					$display("Error detected. CC 1 failure");
					$stop;
				end
			end
		end

		if(C == 2) begin
			if(Z == 0 && N == 0) begin
				if(PC_Out != PC_ref_take) begin
					$display("Error detected. CC 2 failure");
					$stop;
				end
			end

			else begin
				if(PC_Out != PC_ref_nott) begin
					$display("Error detected. CC 2 failure");
					$stop;
				end
			end
		end

		if(C == 3) begin
			if(N == 1) begin
				if(PC_Out != PC_ref_take) begin
					$display("Error detected. CC 3 failure");
					$stop;
				end
			end

			else begin
				if(PC_Out != PC_ref_nott) begin
					$display("Error detected. CC 3 failure");
					$stop;
				end
			end
		end

		if(C == 4) begin
			if(Z == 1 || (Z == N && N == 0)) begin
				if(PC_Out != PC_ref_take) begin
					$display("Error detected. CC 4 failure");
					$stop;
				end
			end

			else begin
				if(PC_Out != PC_ref_nott) begin
					$display("Error detected. CC 4 failure");
					$stop;
				end
			end
		end

		if(C == 5) begin
			if(N == 1 || Z == 1) begin
				if(PC_Out != PC_ref_take) begin
					$display("Error detected. CC 5 failure");
					$stop;
				end
			end

			else begin
				if(PC_Out != PC_ref_nott) begin
					$display("Error detected. CC 5 failure");
					$stop;
				end
			end
		end

		if(C == 6) begin
			if(V == 1) begin
				if(PC_Out != PC_ref_take) begin
					$display("Error detected. CC 6 failure");
					$stop;
				end
			end

			else begin
				if(PC_Out != PC_ref_nott) begin
					$display("Error detected. CC 6 failure");
					$stop;
				end
			end
		end

		if(C == 7) begin
			
			if(PC_Out != PC_ref_take) begin
					$display("Error detected. CC 7 failure");
					$stop;
			end
		end
	end

	initial begin
		assign clock = 0;
		assign PC_In = 0;
		assign C = 0;
		assign I = 0;
		assign F = 0;

	 	#2000000 begin
			$display("Test finished. If no errors were presented, the test has completed successfully");
			$stop;
			$finish;
		end
	end

endmodule
