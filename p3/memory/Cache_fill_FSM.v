/* Cache Fill FSM Controller
 *  
 * wchen329@wisc.edu
 */
module cache_fill_FSM(clk, rst_n, miss_detected, miss_address, fsm_busy, write_data_array, write_tag_array, memory_address, memory_data, memory_data_valid);

input clk, rst_n;
input miss_detected;
input [15:0] miss_address;
input [15:0] memory_data;
input memory_data_valid;

output fsm_busy;
output write_data_array;
output write_tag_array;
output [15:0] memory_address;


// Register Wires
wire [3:0] count_reg_D, count_reg_Q;
wire 	exception,	// held when handling miss
	fsm_active,
	handling_done;	// held when all is done with handling a miss
wire [15:0] base_address; // address with 0 offset
wire [15:0] current_address;	// base address for miss handling. First, fetch from bit offset 0, then 2, 4, 6, 8, 10, 12, 14.
wire [15:0] next_address; // next address state
wire [15:0] current_address_plus_two;

// Implementation Detail
BitCell EXCEPTION_STATE(clk, ~rst_n | handling_done, miss_detected, 1'b1, 1'b1, 1'b0, exception, ); // a bit cell which captures the error state of a miss detected

Register_4bit COUNT_REG(clk, ~fsm_active | ~rst_n | handling_done, count_reg_D , (count_reg_Q != 8) & (memory_data_valid), 1'b1, 1'b0, count_reg_Q, ); // holds the current "count state"
Register WORKING_ADDRESS(clk, ~fsm_active | ~rst_n | handling_done, next_address, 1'b1, 1'b1, 1'b0, current_address);

// Incrementer for segment count and delay count 
adder_4bit_cla_simple COUNT_REQ_INC(,, count_reg_D, count_reg_Q, 1, 1'b0); 

// Increment the current address by two
adder_16bit_cla_simple ADDRESS_INC(current_address_plus_two, current_address, 2);

// Wire assignments
assign base_address = {miss_address[15:4], {4'b0000}};

// Assign state
assign fsm_active = //exception |
			miss_detected; 
assign next_address = (count_reg_Q == 0) ? base_address :
			(memory_data_valid) ? current_address_plus_two
			: current_address;
assign handling_done = (count_reg_Q == 8) ? 1 : 0;

// Assign state outputs
assign write_tag_array = (count_reg_Q == 8) ? 1 : 0;
assign write_data_array = (memory_data_valid) ? 1 : 0;
assign fsm_busy = fsm_active & ~handling_done;
assign memory_address = current_address;

endmodule