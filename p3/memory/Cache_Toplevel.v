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
 * lru == 0 ? (least recently used) : (not most recently used);
 *
 * Cache blocks of the same set are not aligned adjacent in the cache.
 * Each line in a set is separated by 64 other blocks (64 block offset in
 * data).
 *
 * In the cache array, they are indexed on a set bases in parallel to the two
 * tag arrays.
 *
 * wchen329@wisc.edu
 */
module Cache_Toplevel(clk, rst, Address_Oper, store, r_enabled, cacheop, Data_In, Data_Out, miss_occurred);

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
	
	wire [127:0] block_decode_data;	// the block to get or store to for data 
	wire [127:0] block_decode_ze;	// zero extended variant of block_decode
	wire [64:0] block_decode;	// the block to get or store to
	wire [7:0] word_select;		// the word within the block to retrieve
	wire [7:0] tag_in_full;		// full tag in
	wire [1:0] valids;		// the valid bits valids[0] is for WAY_0 and valids[1] is for WAY_1,
	wire [1:0] lrus_n;		// ACTIVE LOW SIGNAL. lrus == 00, cache cold, lrus == 10, WAY_0 is subject to be evicted, lrus == 01, WAY_1 is subject to be evicted, lrus==11 error?
	wire [5:0] tag_in;		// tag to update the cache with
	wire [7:0] tag_out_0, tag_out_1;// actual tag contained in block
	wire [5:0] set_index;		// set index of current request
	wire cache_data_we;		// data write enable, passed from Fill FSM
	wire cache_tag_we;		// tag write enable, passed from Fill FSM

	// Raw Data Outputs
	
	wire [15:0] DataArray_Out;	// raw data leaving cache array
	wire [7:0] tag_raw_out_0, tag_raw_out_1;
					// raw tag block, contains LRU and valid


	// Cache State Elements
	BitCell WAY(.clk(clk), .rst(rst | ~r_enabled | cc_valid), .D(1), .ReadEnable1(1), .Bitline1(way_scan));
	
	// Assign wire signals

	/* Evaluate cache miss signal
	 * In order to evaluate the miss signal, "speculate" cache hit first,
	 * meaning read from data and tag in the same cycle. This will allow
	 * for a tag comparison in the same cycle. If it happens to be a miss,
	 * just disable the read and raise the cache_stall / miss signal.
	 */

	assign miss_occurred = r_enabled & ~( valids[0] & (tag_in == tag_out_0) | valids[1] & (tag_in == tag_out_1) );
	assign Data_Out = DataArray_Out;
	assign cache_data_we = cacheop == 2'b01 ? 1 : 0;
	assign cache_tag_we = cacheop == 2'b10 ? 1 : 0;
	assign tag_in = Address_Oper[15:10];
	assign tag_out = tag_raw_out[5:0];
	assign set_index = Address_Oper[9:4];
	assign valids = {tag_out_1[7] . tag_out_0[7]}
	assign block_decode_data = lrus == 0 ? block_decode_ze : block_decode_ze << 64;
 	assign word_select = Address_Oper[3:1]; // For FSM designer: change these address bits to change word offset index
	assign lrus_n = {tag_out_1[6], tag_out_0[6]}; 

	// Write assignments	
	assign tag_in_full = {1'b1, 1, tag_in};

	// Create an admittedly giant decoder
	Decoder_6_64 DECODER(set_index, block_decode);

	// Cache Arrays
	DataArray CACHE_DATA(.clk(clk), .rst(rst), .DataIn(Data_In), .Write(cache_data_we), .BlockEnable(block_decode_data), .WordEnable(word_select), .DataOut(DataArray_Out));
	MetaDataArray TAG_ARRAY_WAY_0(.clk(clk), .rst(rst), .DataIn(tag_in_full), .Write(cache_tag_we & ~lrus_n[0]), .BlockEnable(block_decode), .DataOut(tag_raw_out_0));
	MetaDataArray TAG_ARRAY_WAY_1(.clk(clk), .rst(rst), .DataIn(tag_in_full), .Write(cache_tag_we & ~lrus_n[1] & (lrus_n[0])), .BlockEnable(block_decode), .DataOut(tag_raw_out_1));	// include way_evict[0] so that on cold misses, only the 0 way writes

endmodule
