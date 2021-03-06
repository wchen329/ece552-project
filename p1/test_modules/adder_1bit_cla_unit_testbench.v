/* Simple test bench for 1-bit full adder 
 *
 * wchen329@wisc.edu
 */
module adder_1bit_cla_unit_testbench();

reg A, B;
reg clock;
reg ref_P, ref_G;
wire P, G;
reg sum_1, sum_2;

adder_1bit_cla_unit ADDER_CLA_UNIT(P, G, A, B);

always #50 assign clock = ~clock;

always @(posedge clock) begin
	assign {A, B} = {A, B} + 1;
end

// Probe
always @(negedge clock) begin
	assign {ref_P, sum_1} = A + B + 1;
	assign {ref_G, sum_2} = A + B;

	if(ref_P != P) begin
		$display("Error detected. Propagate not correctly set.");
		$stop;
	end

	if(ref_G != G) begin
		$display("Error detected. Generate not correctly set.");
		$stop;
	end
end

initial begin
	assign clock = 0;
	assign A = 0;
	assign B = 0;
	#800 begin
		$display("Test finished. If no errors were reported, then test(s) finished without errors.");
		$stop;
	end
end

endmodule