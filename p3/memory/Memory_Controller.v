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
module Memory_Controller(clk, rst, if_we, dm_we, d_enable, if_addr, dm_addr,
				if_data_out, dm_data_out, if_data_in, dm_data_in, if_miss, dm_miss);
	// Inputs
	input clk;			// clock
	input rst;			// active high sync. reset
	input d_enable;			// cache enable or no (disabling this disables having false misses)
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
	wire [1:0] miss_states;
	wire [1:0] fsm_state, fsm_state_0, fsm_state_1, cacheop_1;
	wire fsm_active;
	wire mm_ren;
	wire store;
	wire driving;
	wire valid_data_state;

	// Special wires used for cache
	wire [15:0] I_cache_addr_in;
	wire [15:0] D_cache_addr_in;
	wire [15:0] I_data_in;
	wire [15:0] D_data_in;
	wire [3:0] I_word_index;
	wire [3:0] D_word_index;

	// Wires specificially for driving the FSM
	wire [15:0] fsm_address_in;
	wire [15:0] fsm_data_in;
	wire [15:0] working_address; // address FOR MEMORY ONLY
	wire [15:0] work_and_store_address;
	wire [15:0] work_addr_cache;
	wire fsm_data_fill;
	wire fsm_tag_fill;
	wire fsm_working;
	wire fsm_store_update;	// a special flag which keeps the FSM running when a store operation has reached the correct word
	wire arb_hammer;
	wire update_enable;
	wire store_data_hit_enable;

	// Two caches, I-cache, D-cache
	Cache_Toplevel I_CACHE(.clk(clk), .rst(rst), .Address_Oper(I_cache_addr_in) , .r_enabled(1'b1), .cacheop(fsm_state_0), .Data_In(I_data_in), .Data_Out(if_data_out), .miss_occurred(if_miss));
	Cache_Toplevel D_CACHE(.clk(clk), .rst(rst), .Address_Oper(D_cache_addr_in) , .r_enabled(d_enable), .cacheop(cacheop_1), .Data_In(D_data_in), .Data_Out(dm_data_out), .miss_occurred(dm_miss));

	// THE Main Memory Module
	memory4c MAIN_MEMORY(.data_out(mm_out), .data_in(mm_in), .addr(work_and_store_address), .enable((|miss_states & ~mm_ren) | update_enable | store_data_hit_enable), .wr(update_enable | store_data_hit_enable), .clk(clk), .rst(rst), .data_valid(valid_data_state));

	assign dm_data_out = cacheop_1 == 2'b01 ? {16{1'b0}} : {16{1'bz}};

	assign store_data_hit_enable = store & ~fsm_active;
	assign update_enable = miss_states == 2'b01 & store & fsm_tag_fill;

	assign fsm_store_update = store ?
					fsm_data_fill == 1 ?
						dm_addr[3:0] == work_addr_cache[3:0] ? 1 : 0
					: 0
				: 0;

	assign cacheop_1 = store_data_hit_enable ? 2'b01 : fsm_state_1;

	assign work_and_store_address =
		miss_states == 2'b01 ?				
			store ?
				fsm_tag_fill ?
					fsm_address_in
				: working_address
			: working_address
		:

		store_data_hit_enable ? dm_addr : working_address;

	//assign mm_out = ~(|miss_states & ~mm_ren) ? {16{1'b0}} : {16{1'bz}};
	assign if_data_out = if_miss ? {16{1'b0}} : {16{1'bz}};
	assign dm_data_out = dm_miss ? {16{1'b0}} :
				~d_enable ? {16{1'b0}} : {16{1'bz}};

	// Define Fill FSM
	assign I_word_index = if_miss ?
					fsm_data_fill == 1 ? work_addr_cache[3:0] : if_addr[3:0]
				: if_addr[3:0];

	assign D_word_index = dm_miss ?
					fsm_data_fill == 1 ? work_addr_cache[3:0] : dm_addr[3:0]
				: dm_addr[3:0];

	// If not missing, don't write to the cache (i.e. write cache with what's already in there)!
	// However, if missing then:
		// I cache - write what's retrived from main memory
		// D cache - write input data if store otherwise write what's retrieved from main memory

	assign I_data_in =	if_miss ?
					mm_out	// can add a store signal for if in future if needed
				: if_data_out;
		
	assign D_data_in =	dm_miss ?
					store ? 
						fsm_store_update ? dm_data_in : mm_out
					: mm_out
				:

				store_data_hit_enable ? dm_data_in : dm_data_out; 

	assign I_cache_addr_in = { if_addr[15:4], I_word_index };
	assign D_cache_addr_in = { dm_addr[15:4], D_word_index };

	assign miss_states = {if_miss, dm_miss & d_enable};

	// Decide which bus gets to go use the FSM, is will always be
	// the I-mem if both miss, following the D-mem
	assign driving =	miss_states == 2'b01 ? 0 :	// if only d-mem miss, drive with d-mem
				miss_states == 2'b10 ? 1 :	// if only i-mem miss, drive with i-mem
				miss_states == 2'b11 ? 1 : 0;	// if both miss drive with i-mem, also if no miss don't care

	assign fsm_active =	miss_states == 2'b00 ? 0 : 1;	// fsm is not active if no miss, but is active if any miss happens

	assign fsm_state =	fsm_tag_fill == 1 ? 2'b10 :		// fsm is trying to fill tags
				fsm_data_fill == 1 ? 2'b01 :		// fsm is trying to fill data
 					2'b00;	

	// FSM States for each D-mem and I-mem
	assign fsm_state_0 = if_miss ?			// If there's no miss, just read, otherwise assign to fsm_state depending if driving or not
					driving == 1 ? fsm_state : 2'b00
				: 2'b00 ;

	assign fsm_state_1 = dm_miss ?
					driving == 0 ? fsm_state : 2'b00
				: 2'b00 ; 

	// DRIVING == 1 ? I-cache and I-bus drives : D-cache and D-bus drives
	assign fsm_address_in	= driving == 1 ? if_addr : dm_addr;	// select correct address depending on what's driving the fsm (DATA or IF?)
	assign mm_addr = fsm_address_in;
	assign store = dm_we;

	// NOTE: this signal may not be needed?
	assign fsm_data_in 	= 	store ?
						driving == 1 ? if_data_in : dm_data_in	// select correct data depending on what's driving the fsm
					: mm_out;
	assign arb_hammer = miss_states == 2'b11 ?
				fsm_tag_fill == 1 ? 1 : 0
			: 2'b00;

	assign mm_in	=	driving == 1 ? if_data_in : dm_data_in;

	// FSM declaration
	Cache_fill_FSM FILL_FSM(.clk(clk), .rst_n(~(~fsm_active | rst)), .miss_detected(fsm_active), .miss_address(fsm_address_in), .fsm_busy(fsm_working), .write_data_array(fsm_data_fill), 
		.write_tag_array(fsm_tag_fill), .memory_address(working_address), .cache_wr_address(work_addr_cache), .memory_data(fsm_data_in), .arb_force_reset(arb_hammer), .memory_data_valid(valid_data_state), .EOB(mm_ren));


endmodule
