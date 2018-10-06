/* A simple 4x4-bit adder
 * Adds four 4-bit subwords in parallel
 *
 * wchen329@wisc.edu
 */
module PSA_16bit(Sum, Error, A, B);

input [15:0] A, B;
output [15:0] Sum;
output Error;

// Each of the four words of output
wire [3:0] output_15_12, output_11_8, output_7_4, output_3_0;
wire error_15_12, error_11_8, error_7_4, error_3_0;

// Now find the sum and error of each word subsection
addsub_4bit BLOCK_3(output_15_12, error_15_12, A[15:12], B[15:12], 0); 
addsub_4bit BLOCK_2(output_11_8, error_11_8, A[11:8], B[11:8], 0);
addsub_4bit BLOCK_1(output_7_4, error_7_4, A[7:4], B[7:4], 0);
addsub_4bit BLOCK_0(output_3_0, error_3_0, A[3:0], B[3:0], 0);

// Assign Error and Sum values
assign Error = (error_15_12 | error_11_8 | error_7_4 | error_3_0);
assign Sum = {output_15_12, output_11_8, output_7_4, output_3_0};

endmodule