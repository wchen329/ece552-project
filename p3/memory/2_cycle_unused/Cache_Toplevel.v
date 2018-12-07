/* A toplevel for a cache that connects to the cpu toplevel
 * The Cache Toplevel encapsulates a Cache Data Array and Tag Array 
 * and connects to the Main Memory task arbritrator / FSM in the event of a single
 *
 * Addresses are 16 bits. Caches are 2 way associative, which results in 64
 * sets. Each cache block is 16
 * bytes.
 *
 * Addresses are thus partitioned as:
 * [ 6 ]   [ 6 ]   [ 4 ]
 * tag     set     byte offset
 *
 * Furthermore, each tag array block has 8 bit buses. The tag array block is
 * partitioned as follows:
 *
 * [ 1 ]   [ 1 ]   [ 6 ]
 * valid   lru     tag
 *
 * lru == 1 ? (least recently used) : (not most recently used);
 *
 * Cache blocks of the same set are aligned adjacent in the cache. For example
 * set 0 have as members both blocks 0 and 1. First block in a set is therein
 * 2n where n is the set number
 *
 * wchen329@wisc.edu
 */
module Cache_Toplevel(clk, rst, Address_Oper, store, r_enabled, cacheop, Data_In, Data_Out, miss_occurred, way_misprediction);

	// Input List

	input clk;			// Clock signal
	input rst;			// reset signal
	input [15:0] Address_Oper;	// address to perform memory operation
	input [15:0] Data_In;		// input data to be used in case of a store
	input store;			// true if store, false if load
	input r_enabled;		// true if operation is memory operation, false if not memory operation
	input [1:0] cacheop;		// encoded control signals for FSM to perform operations on caches. 0 = read, 1 = fill, 2 = set cache tag, 3 = X

	// Output List
	
	output miss_occurred;		// miss detected, assert!
	output way_misprediction;	// if way is not zero, then mispredicted
	output [15:0] Data_Out;		// output data in case of load


	// Internal wiring
	
	wire cc_valid;			// current cycle request is valid?
	wire cc_lru;			// current cycle is lru block?
	wire [127:0] block_decode;	// the block to get or store to
	wire [7:0] word_select;		// the word within the block to retrieve
	wire [5:0] tag_in;		// tag to update the cache with
	wire [5:0] tag_out;		// actual tag contained in block
	wire [5:0] set_index;		// set index of current request
	wire cache_data_we;		// data write enable, passed from Fill FSM
	wire cache_tag_we;		// tag write enable, passed from Fill FSM
	wire way_scan;			// the current cache way in initial scan
	wire way_miss;			// the cache way to fill if a miss
	wire actual_way;		// actual way used for cache indexing
	wire hit;			// a hit that may be eventual but a hit nonetheless

	// Raw Data Outputs
	
	wire [15:0] DataArray_Out;	// raw data leaving cache array
	wire [7:0] tag_raw_out;		// raw tag block, contains LRU and valid


	// Cache State Elements
	BitCell WAY(.clk(clk), .rst(rst | ~r_enabled | cc_valid), .D(1), .ReadEnable1(1), .Bitline1(way_scan));
	
	/* The LRU Miss Handler
 	 * This FSM only assumes the worst, it will take in the LRU of the
 	 * first read, then the second read if it occurs, and if there is
 	 * a miss then it will output the correct associativity to index into
 	 * for cache misses.
 	 *
 	 * Mealy. Takes in input and stores it the same cycle on the second
 	 * cycle.
 	 *
 	 */
	LRU_MissHandler_FSM LMHANDLER(.clk(clk), .rst(rst | ~r_enabled), .LRU_in(cc_lru), .current_way(way_scan), .correct_way(way_miss)); 

	// Assign wire signals

	/* Evaluate cache miss signal
	 * In order to evaluate the miss signal, "speculate" cache hit first,
	 * meaning read from data and tag in the same cycle. This will allow
	 * for a tag comparison in the same cycle. If it happens to be a miss,
	 * just disable the read and raise the cache_stall / miss signal.
	 */

	assign miss_occurred = ~hit & r_enabled & way_scan; // a miss if the read tag is different from tag to write, or not valid, but only on second attempt
	assign Data_Out = DataArray_Out;
	assign cache_data_we = cacheop == 2'b01 ? 1 : 0;
	assign cache_tag_we = cacheop == 2'b10 ? 1 : 0;
	assign tag_in = Address_Oper[15:10];
	assign tag_out = tag_raw_out[5:0];
	assign cc_lru = tag_raw_out[6];
	assign cc_valid = tag_raw_out[7];
	assign set_index = Address_Oper[9:4];
	assign actual_way = (way_scan & ~miss_occurred) | (way_miss & miss_occurred);
	assign hit = cc_valid & (tag_in == tag_out);

 	assign word_select = Address_Oper[3:1]; // For FSM designer: change these address bits to change word offset index


	// Create an admittedly giant decoder
	Decoder_7_128 DECODER({set_index, actual_way }, block_decode); 

	// Cache Arrays
	DataArray CACHE_DATA(.clk(clk), .rst(rst), .DataIn(Data_In), .Write(cache_data_we), .BlockEnable(block_decode), .WordEnable(word_select), .DataOut(DataArray_Out));
	MetaDataArray TAG_ARRAY(.clk(clk), .rst(rst), .DataIn(tag_in), .Write(cache_tag_we), .BlockEnable(block_decode), .DataOut(tag_out));

endmodule
