/* Simple test bench for 1-bit full adder 
 *
 * wchen329@wisc.edu
 */
module adder_1bit_partial_testbench();

reg A, B, Cin;
reg clock;
wire Sum;

adder_1bit_partial ADDER(Sum, A, B, Cin);

always #50 assign clock = ~clock;

always @(posedge clock) begin
	assign {Cin, A, B} = {Cin, A, B} + 1;
end

always @(negedge clock) begin
	if(Sum != A + B + Cin) begin
		$display("Error detected. Sum mismatch");
		$stop;
	end
end

initial begin
	assign clock = 0;
	assign A = 0;
	assign B = 0;
	assign Cin = 0;
	#800 begin
		$display("Test finished. If no errors were printed, then tests passed successfully.");
		$stop;
	end
end

endmodule