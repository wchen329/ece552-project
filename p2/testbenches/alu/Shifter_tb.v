module Shifter_tb();
    // by Zhenghao
    reg[15:0] IN;
    reg[3:0] offset;
    reg[2:0] opcode;
    wire[15:0] OUT;

    reg[63:0] i;
    reg[31:0] o;
    reg[15:0] ANS;
    reg signed[15:0] tmp;

    Shifter DUT(OUT, IN, offset, opcode);
    initial begin

        // small test for ROR
        opcode = 3'b010;
        offset = 4'b1111;
        IN = 16'h0001;
        #1;
        $display("expected: 2, got: %d", OUT);
        //$finish;


        // SLL Testing
        opcode = 3'b000;
        for (o = 0; o < 16; o=o+1) begin
            offset = o[3:0];
            for (i=0;i<=64'hFFF;i=i+1) begin
                IN = $random;
                #1;
                ANS = IN << offset;
                if (OUT != ANS) $display("SLL Test fail. IN:%d, offset:%d, ANS:%d, OUT:%d", IN, offset, ANS, OUT);
            end
        end
        $display("SLL tests complete");

        // SRA Testing
        opcode = 3'b001;
        for (o = 0; o < 16; o=o+1) begin
            offset = o[3:0];
            for (i=0;i<=64'hFFF;i=i+1) begin
                IN = $random;
                #1;
                tmp = IN;
                ANS = tmp >>> offset;
                if (OUT != ANS) $display("SRA Test fail. IN:%d, offset:%d, ANS:%d, OUT:%d", IN, offset, ANS, OUT);
            end
        end
        $display("SRA tests complete");

        // ROR Testing
        opcode = 3'b010;
        for (o = 0; o < 16; o=o+1) begin
            offset = o[3:0];
            for (i=0;i<=64'hFFF;i=i+1) begin
                IN = $random;
                #1;
                ANS = {IN, IN} >> offset;
                if (OUT != ANS) $display("ROR Test fail. IN:%d, offset:%d, ANS:%d, OUT:%d", IN, offset, ANS, OUT);
            end
        end
        $display("ROR tests complete");

        $finish;
    end
endmodule

/* A simple exhaustive testbench for the shifter. This one only tests SLL and SRA.
 * ROR has its own testbench.
 *
 * Runs for all 2^21 cases so exhaustive indeed.
 *
 * wchen329@wisc.edu
 */
module Shifter_3_1_sll_sra_tb();

	reg clock;
	reg [1:0] shift_mode;
	reg [15:0] A;
	reg [3:0] shift_arg;

	wire [15:0] test_output;

	Shifter DUT(test_output, A, shift_arg, shift_mode);

	always #100 assign clock = ~clock;

	// Assign new test values
	always @(posedge clock) begin
		assign {shift_mode, shift_arg, A} = {shift_mode, shift_arg, A} + 1;
	end

	// Probe and produce errors if needed
	always @(negedge clock) begin

		// Test correct shift left
		if(shift_mode == 0) begin
			if(test_output != (A << shift_arg)) begin
				$display("An error occurred: Left shift test failed.");
				$finish;
			end
		end

		// Test correct right shift
		if(shift_mode == 1) begin
			if(test_output != ((A >> shift_arg) | -(A[15] << (15 - shift_arg)))) begin
				$display("An error occurred: Right shift test failed.");
				$finish;
			end
		end
	end

	initial begin
		assign A = 0;
		assign clock = 0;
		assign shift_mode = 0;
		assign shift_arg = 0;
		#419430400 begin
			 $display("Test completed successfully. If this is the first time the test has stopped automatically then it has completed without errors");
			 $finish;
			 $finish;
		end
	end

endmodule

/* A simple exhaustive testbench for the shifter. This one for ROR.
 *
 * Runs for all 2^20 cases so exhaustive indeed.
 *
 * wchen329@wisc.edu
 */
module Shifter_3_1_ror_tb();

	reg clock;
	reg [15:0] A;
	reg [3:0] shift_arg;
	reg [31:0] working;
	reg [15:0] reference_output;

	wire [15:0] test_output;


	Shifter DUT(test_output, A, shift_arg, 3'b110);

	always #100 assign clock = ~clock;

	// Assign new test values
	always @(posedge clock) begin
		assign {shift_arg, A} = {shift_arg, A} + 1;
		assign working = {A, {16{1'b0}}};
		assign working = (working >> shift_arg);
		assign reference_output = working[15:0] | working[31:16];
	end

	// Probe and produce errors if needed
	always @(negedge clock) begin
		if(reference_output != test_output) begin
			$display("Error detected. ROR mismatch");
			$finish;
		end
	end

	initial begin
		assign A = 0;
		assign clock = 0;
		assign shift_arg = 0;
		assign working = 0;
		assign reference_output = 0;
		#209715200 begin
			 $display("Test completed successfully. If this is the first time the test has stopped automatically then it has completed without errors");
			 $finish;
			 $finish;
		end
	end

endmodule
