/* Memory Controller interface for Toplevel
 * 
 * The FSM will submit read requests to each cache. If a cache misses, then it
 * will raise a signal that will
 *	(1) stall the pipeline
 *	(2) initiate a cache Fill
 * 	(3) go back to reading once the cache block and tag is filled
 *
 * If both MEM and IF miss at the same time, then IF will read in first and
 * MEM will read in after IF is done.
 *
 * wchen329@wisc.edu
 */
module Memory_Controller(clk, rst, d_enable, if_we, dm_we, if_addr, dm_addr,
				if_data_out, dm_data_out, if_data_in, dm_data_in, if_miss, dm_miss);
	// Inputs
	input clk;			// clock
	input rst;			// active high sync. reset
	input d_enable;			// enable signal for d-mem bus
	input if_we;			// instruction fetch bus write enable
	input dm_we;			// data memory bus write enable
	input [15:0] if_addr;		// address for instruction fetch bus
	input [15:0] dm_addr;		// address for data memory bus
	input [15:0] if_data_in;	// data inputs for instruction fetch stage bus
	input [15:0] dm_data_in;	// data inputs for data memory stage bus

	// Outputs
	output [15:0] if_data_out;	// data read from i_cache if any
	output [15:0] dm_data_out;	// data read from d_cache if any
	output if_miss;			// if miss signal, used for sending no-ops into the pipeline or stalling
	output dm_miss;			// dm miss signal, used for sending no-ops into the pipeline or stalling
	

	// Internal Wiring
	wire [15:0] mm_in;
	wire [15:0] mm_out;
	wire [15:0] mm_addr;
	wire [1:0] miss_state;
	wire [1:0] fsm_state;
	wire fsm_active;
	wire store;
	wire driving;
	wire valid_data_state;

	// Special wires used for cache
	wire [15:0] I_Cache_addr_in;
	wire [15:0] D_cache_addr_in;
	wire [3:0] I_word_index;
	wire [3:0] D_word_index;

	// Wires specificially for driving the FSM
	wire [15:0] fsm_address_in;
	wire [15:0] fsm_data_in;
	wire [15:0] working_address;
	wire fsm_data_fill;
	wire fsm_tag_fill;
	wire fsm_working;

	// Two caches, I-cache, D-cache
	Cache_Toplevel I_CACHE(.clk(clk), .rst(rst), .Addr_Oper(I_cache_addr_in) .r_enabled(1'b1), .cacheop(fsm_state), .Data_In(if_data_in), .Data_Out(if_data_out), .miss_occurred(if_miss));
	Cache_Toplevel D_CACHE(.clk(clk), .rst(rst), .Addr_Oper(D_cache_addr_in) , .r_enabled(1'b1), .cacheop(fsm_state), .Data_In(dm_data_in), .Data_Out(dm_data_out), .miss_occurred(dm_miss));

	// THE Main Memory Module
	memory4c MAIN_MEMORY(.data_out(mm_out), .data_in(mm_in), .addr(mm_addr), 1'b1, .wr(store), .clk(clk), .rst(rst), .data_valid(valid_data_state));

	// Define Fill FSM

	assign I_word_index = if_miss ?
					fsm_data_fill == 1 ? working_address[3:0];	
				: if_addr[3:0];

	assign D_word_index = dm_miss ?
					fsm_data_fill == 1 ? working_address[3:0];
				: dm_addr[3:0];

	assign I_cache_addr_in = { if_addr[15:4], I_word_index };
	assign D_cache_addr_in = { dm_addr[15:4], D_word_index };

	assign miss_states = {if_miss, dm_miss};

	// Decide which bus gets to go use the FSM, is will always be
	// the I-mem if both miss, following the D-mem
	assign driving =	miss_states == 2'b01 ? 0 :	// if only d-mem miss, drive with d-mem
				miss_states == 2'b10 ? 1 :	// if only i-mem miss, drive with i-mem
				miss_states == 2'b11 ? 1 : 0;	// if both miss drive with i-mem, also if no miss don't care

	assign fsm_active =	miss_states == 2'b00 ? 0 : 1;	// fsm is not active if no miss, but is active if any miss happens

	assign fsm_state =	fsm_data_fill == 1 ? 2'b01 :		// fsm is trying to fill data
				fsm_tag_fill == 1 ? 2'b10 : 2'b00	// fsm is trying to fill tags, if not trying to fill anything it's reading still
	// DRIVING == 1 ? I-mem drives : D-mem drives
	assign fsm_address_in	= driving == 1 ? if_addr : dm_addr;	// select correct address depending on what's driving the fsm (DATA or IF?)

	assign fsm_data_in 	= driving == 1 ? if_data : dm_data;	// select correct data depending on what's driving the fsm

	// FSM declaration
	Cache_fill_FSM FILL_FSM(.clk(clk), .rst_n(~fsm_active), .miss_detected(fsm_active), .miss_address(fsm_address_in), .fsm_busy(fsm_working), .write_data_array(fsm_data_fill), 
		.write_tag_array(fsm_tag_fill), .memory_address(working_address), .memory_data(fsm_data_in), .memory_data_valid(valid_data_state));


endmodule
