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
 *
 * In the cache array, they are indexed on a set bases in parallel to the two
 * tag arrays.
 *
 * General tip: Write the tag last. The data takes several cycles to write
 * but the tag write is atomic. So write the data first as when the tag is
 * written, the transaction is commited and the LRU switches around
 *
 * wchen329@wisc.edu
 */
module Cache_Toplevel(clk, rst, Address_Oper, r_enabled, cacheop, Data_In, Data_Out, miss_occurred);

	// Input List

	input clk;			// Clock signal
	input rst;			// reset signal
	input [15:0] Address_Oper;	// address to perform memory operation
	input [15:0] Data_In;		// input data to be used in case of a store
	input r_enabled;		// true if operation is memory operation, false if not memory operation
	input [1:0] cacheop;		// encoded control signals for FSM to perform operations on caches. 0 = read, 1 = fill, 2 = set cache tag, 3 = X

	// Output List
	
	output miss_occurred;		// miss detected, assert!
	output [15:0] Data_Out;		// output data in case of load


	// Internal wiring
	
	wire [127:0] block_decode_data;	// the block to get or store to for data 
	wire [127:0] block_decode_ze;	// zero extended variant of block_decode
	wire [63:0] block_decode;	// the block to get or store to
	wire [7:0] tag_in_full_0, tag_in_full_1;
					// full tag in for ways 0 and 1 
	wire [1:0] valids;		// the valid bits valids[0] is for WAY_0 and valids[1] is for WAY_1,
	wire [1:0] lrus_n;		/* ACTIVE LOW SIGNAL inorder to work with reset. Raw signal, use miss_way instead. lrus == 00, cache cold,
					 * lrus == 10, WAY_0 is subject to be evicted, lrus == 01, WAY_1 is subject to be evicted, lrus==11 error?
					 */
	wire [5:0] tag_in;		// tag to update the cache with
	wire [5:0] tag_out_0, tag_out_1;// actual tag contained in block
	wire [5:0] set_index;		// set index of current request
	wire cache_data_we;		// data write enable, passed from Fill FSM
	wire cache_tag_we;		// tag write enable, passed from Fill FSM
	wire hit_way_0, hit_way_1;	// if way 0 or way 1 produce hits, raise a high signal
	wire [1:0] miss_way;		// only one on at a time, which one missed? similar to LRUs signal but ~ and explicitly one hot (i.e. a cold miss resolves in 1'b01, a miss in way 0).
	wire [1:0] lru_next;		// next state LRU value
	wire [5:0] tag_next_0, tag_next_1;
					// next state tag value
	wire [2:0] word_select;		// the word within the block to retrieve
	wire [7:0] ws_one_hot;		// word select one hot signal

	wire valid_next_0;		// next state valid bit for way 0
	wire valid_next_1;		// next state valid bit for way 1

	// Raw Data Outputs
	
	wire [15:0] DataArray_Out;	// raw data leaving cache array
	wire [7:0] tag_raw_out_0, tag_raw_out_1;
					// raw tag block, contains LRU and valid
	
	// Assign wire signals

	/* Evaluate cache miss signal
	 * In order to evaluate the miss signal, "speculate" cache hit first,
	 * meaning read from data and tag in the same cycle. This will allow
	 * for a tag comparison in the same cycle. If it happens to be a miss,
	 * just disable the read and raise the cache_stall / miss signal.
	 */

	assign hit_way_0 = valids[0] & (tag_in == tag_out_0);
	assign hit_way_1 = valids[1] & (tag_in == tag_out_1);
	assign miss_occurred = r_enabled & ~(hit_way_0 | hit_way_1);
	assign hit_occurred = r_enabled & (hit_way_0 | hit_way_1);
	assign Data_Out = DataArray_Out;
	assign tag_in = Address_Oper[15:10];
	assign tag_out_0 = tag_raw_out_0[5:0];
	assign tag_out_1 = tag_raw_out_1[5:0];
	assign set_index = Address_Oper[9:4];
	assign valids = {tag_raw_out_1[7], tag_raw_out_0[7]};
	assign block_decode_ze = {{64{1'b0}}, block_decode};
	//assign block_decode_data =  == 0 ? block_decode_ze : block_decode_ze << 64;
 	assign word_select = Address_Oper[3:1]; 	// For FSM designer: change these address bits to change word offset index when filling
	assign lrus_n = {tag_raw_out_1[6], tag_raw_out_0[6]}; 

	// Assign conditional signals based on FSM states
	assign miss_way = lrus_n == 2'b00 ? 2'b01 : 2'b00; // ~lrus_n;

	assign block_decode_data = cacheop == 2'b00 ? // Reading? Read with hit block only	
					hit_way_0 == 1 ? block_decode_ze :	 // hit with way 0
					hit_way_1 == 1 ? block_decode_ze << 64 : // hit with way 1
					{128{1'b0}}				 // disable, this would be a miss case so doesn't matter anyway
				: {128{1'b0}};	// Disable decoder if not reading

	// Write only when trying to "fill" the cache but the cache tag write
	// happens silently every hit!
	assign cache_data_we = 	r_enabled ?
					cacheop == 2'b01 ? 1 
					: 0
				: 0;
	assign cache_tag_we = 	r_enabled ?
					cacheop == 2'b10 ? 1
					: cacheop == 2'b00 ?
						hit_occurred ? 1 
						: 0
					: 0
				: 0;

	// Write assignments for input tags	

		// Calculate Valid values on the next write
		//
		// Consider
		// 	READ: Valid doesn't change on read.
		//
		// 	FILL DATA: Valid doesn't change on data fill.
		//
		// 	FILL TAGS: Yes, on a miss, the missed way will become
		// 	valid when replaced. A valid block will be assumed to be valid until reset.
		//
	assign valid_next_0 = cacheop == 2'b010 ?
				miss_way[0] == 1 ? 1 : valids[0]
			: valids[0];	

	assign valid_next_1 = cacheop == 2'b010 ?
				miss_way[1] == 1 ? 1 : valids[1]
			: valids[1];	


		// Calculate LRU values on the next write
		//
		// Consider
		// 	READ: LRU will change iff there is a HIT, otherwise it
		// 	will change on FILL TAGS
		//
		// 	FILL DATA: No, this only writes data.
		//
		// 	FILL TAGS: Yes, on a miss, the missed way will become
		// 	the new most recently used, and the least recently
		// 	used is the one which did not get evicted.
	assign lru_next[0] = cacheop == 2'b00 ?

				miss_occurred == 1 ? lrus_n[0]
				: hit_way_0 == 1'b1 ? 1'b1
					: 0'b1

				: cacheop == 2'b10 ?
					miss_way == 2'b01 ? 1'b1 : 1'b0  
				: lrus_n[0];

	assign lru_next[1] = cacheop == 2'b00 ?

				miss_occurred == 1 ? lrus_n[1]
				: hit_way_1 == 1'b1 ? 1'b1
					: 0'b1

				: cacheop == 2'b10 ?
					miss_way == 2'b10 ? 1'b1 : 1'b0 
				: lrus_n[1];

		// Calculate Tag values on the next write (TAG ONLY NOT LRU OR VALID)
		//
		// Consider:
		//	READ: Does not change on read.
		//	FILL DATA: Tags don't change because only writes data
		//	FILL TAGS: Yes, only that writes tags
		//	Within FILL TAGS:
		//		if this is the way that missed fill it with
		//		a new tag
		//
		//		Otherwise don't fill it at all
	assign tag_next_0 = cacheop == 2'b10 ?
				miss_way[0] == 1 ? tag_in : tag_raw_out_0	
			   : tag_out_0;

	assign tag_next_1 = cacheop == 2'b10 ?
				miss_way[1] == 1 ? tag_in : tag_raw_out_1	
			   : tag_out_1;
	
	assign tag_in_full_0 = {valid_next_0, lru_next[0], tag_next_0};
	assign tag_in_full_1 = {valid_next_1, lru_next[1], tag_next_1}; 

	// Create an admittedly giant decoder, decode block number
	Decoder_6_64 DECODER_DATA(set_index, block_decode);

	// Word decoder
	Decoder_3_8 DECODER_WORD(word_select, ws_one_hot);

	// Cache Arrays
	DataArray CACHE_DATA(.clk(clk), .rst(rst), .DataIn(Data_In), .Write(cache_data_we), .BlockEnable(block_decode_data), .WordEnable(ws_one_hot), .DataOut(DataArray_Out));
	MetaDataArray TAG_ARRAY_WAY_0(.clk(clk), .rst(rst), .DataIn(tag_in_full_0), .Write(cache_tag_we), .BlockEnable(block_decode), .DataOut(tag_raw_out_0));
	MetaDataArray TAG_ARRAY_WAY_1(.clk(clk), .rst(rst), .DataIn(tag_in_full_1), .Write(cache_tag_we), .BlockEnable(block_decode), .DataOut(tag_raw_out_1));	// include way_evict[0] so that on cold misses, only the 0 way writes

endmodule
