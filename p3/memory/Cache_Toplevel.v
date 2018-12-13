/* A toplevel for a cache that connects to the cpu toplevel
 * The Cache Toplevel encapsulates a Cache Data Array and Tag Array 
 * and connects to the Main Memory task arbritrator / FSM
 *
 * Addresses are 16 bits. Caches are 4 way associative, which results in 32
 * sets. Each cache block is 16
 * bytes.
 *
 * Addresses are thus partitioned as:
 * [ 7 ]   [ 5 ]   [ 4 ]
 * tag     set     byte offset
 *
 * Furthermore, each tag array block has 8 bit buses. The tag array block is
 * partitioned as follows:
 *
 * [ 1 ]      [ 7 ]
 * valid      tag
 *
 * LRU bits are stored separately in small registers.
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
 * written, the transaction is commited and the LRU switches around.
 *
 * wchen329@wisc.edu
 */
module Cache_Toplevel(clk, rst, Address_Oper, r_enabled, cacheop, Data_In, Data_Out, miss_occurred);


	// LRU Signals
	wire [1:0] lru_w0, lru_w1, lru_w2, lru_w3;

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
	wire [31:0] block_decode;	// the block to get or store to
	wire [7:0] tag_in_full_0, tag_in_full_1, tag_in_full_2, tag_in_full_3;
					// full tag in for ways 0 and 1 
	wire [3:0] valids;		// the valid bits valids[0] is for WAY_0 and valids[1] is for WAY_1,
	wire [6:0] tag_in;		// tag to update the cache with
	wire [6:0] tag_out_0, tag_out_1, tag_out_2, tag_out_3;
					// actual tag contained in block
	wire [4:0] set_index;		// set index of current request
	wire cache_data_we;		// data write enable, passed from Fill FSM
	wire cache_tag_we;		// tag write enable, passed from Fill FSM
	wire hit_way_0, hit_way_1, hit_way_2, hit_way_3;
					// if way 0 or way 1 produce hits, raise a high signal
	wire [3:0] miss_way;		// only one on at a time, which one missed? similar to LRUs signal but ~ and explicitly one hot (i.e. a cold miss resolves in 4'b0001, a miss in way 0).
	wire [6:0] tag_next_0, tag_next_1, tag_next_2, tag_next_3;
					// next state tag value
	wire [2:0] word_select;		// the word within the block to retrieve
	wire [7:0] ws_one_hot;		// word select one hot signal

	wire valid_next_0;		// next state valid bit for way 0
	wire valid_next_1;		// next state valid bit for way 1
	wire valid_next_2;		// for way 2
	wire valid_next_3;

	// Raw Data Outputs
	
	wire [15:0] DataArray_Out;	// raw data leaving cache array
	wire [7:0] tag_raw_out_0, tag_raw_out_1, tag_raw_out_2, tag_raw_out_3;
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
	assign hit_way_2 = valids[2] & (tag_in == tag_out_2);
	assign hit_way_3 = valids[3] & (tag_in == tag_out_3);
	assign miss_occurred = r_enabled & ~(hit_way_0 | hit_way_1 | hit_way_2 | hit_way_3);
	assign hit_occurred = r_enabled & (hit_way_0 | hit_way_1 | hit_way_2 | hit_way_3);
	assign Data_Out = r_enabled ?
					block_decode_data != {128{1'b0}} ?
							DataArray_Out
					: {16{1'b0}}
				: {16{1'b0}};
	assign tag_in = Address_Oper[15:9];
	assign tag_out_0 = tag_raw_out_0[6:0]; assign tag_out_1 = tag_raw_out_1[6:0]; assign tag_out_2 = tag_raw_out_2[6:0]; assign tag_out_3 = tag_raw_out_3[6:0];
	assign set_index = Address_Oper[8:4];
	assign valids = {tag_raw_out_3[7], tag_raw_out_2[7], tag_raw_out_1[7], tag_raw_out_0[7]};
	assign block_decode_ze = {{96{1'b0}}, block_decode};
 	assign word_select = Address_Oper[3:1]; 	// For FSM designer: change these address bits to change word offset index when filling

	// Assign conditional signals based on FSM states

	assign block_decode_data = cacheop == 2'b00 ? // Reading? Read with hit block only	
					hit_way_0 == 1 ? block_decode_ze :
					hit_way_1 == 1 ? block_decode_ze << 32 :
					hit_way_2 == 1 ? block_decode_ze << 64 :
					hit_way_3 == 1 ? block_decode_ze << 96

					: {128{1'b0}}	// disable, this would be a miss case so doesn't matter anyway
				
				: cacheop == 2'b01 ?	// Filling? Make sure to fill the way that the miss occurred
					miss_occurred == 1 ?
						miss_way[0] == 1 ? block_decode_ze :
						miss_way[1] == 1 ? block_decode_ze << 32 :
						miss_way[2] == 1 ? block_decode_ze << 64 :
						miss_way[3] == 1 ? block_decode_ze << 96
						: {128{1'b0}} // if there's no misses then don't write
					: // If there's no miss use the way that is hit
						hit_way_0 == 1 ? block_decode_ze :
						hit_way_1 == 1 ? block_decode_ze << 32 :
						hit_way_2 == 1 ? block_decode_ze << 64 :
						hit_way_3 == 1 ? block_decode_ze << 96
						: {128{1'b0}}	// disable, this would be a miss case so doesn't matter anyway

				: {128{1'b0}};	// finally if not filling or reading don't de anything

	// Write only when trying to "fill" the cache but the cache tag write
	// happens silently every hit!
	assign cache_data_we = 	r_enabled ?
					cacheop == 2'b01 ? 1 
					: 0
				: 0;
	assign cache_tag_we =
					r_enabled ?
						cacheop == 2'b10 ? 1
						: cacheop == 2'b00 ?
							hit_occurred ? 1 
							: 0
						: 0
					: 0;

	// Write assignments for input tags	

		// Calculate Valid values on the next write
		//
		// Consider:
		// 	READ: Valid doesn't change on read.
		//
		// 	FILL DATA: Valid doesn't change on data fill.
		//
		// 	FILL TAGS: Yes, on a miss, the missed way will become
		// 	valid when replaced. A valid block will be assumed to be valid until reset.
		//
	assign valid_next_0 = cacheop == 2'b10 ?
				miss_occurred == 1 ?
					miss_way[0] == 1 ? 1 : valids[0]
				: valids[0]
			: valids[0];	

	assign valid_next_1 = cacheop == 2'b10 ?
				miss_occurred == 1 ?
					miss_way[1] == 1 ? 1 : valids[1]
				: valids[1]
			: valids[1];


	assign valid_next_2 = cacheop == 2'b10 ?
				miss_occurred == 1 ?
					miss_way[2] == 1 ? 1 : valids[2]
				: valids[2]
			: valids[2];	

	assign valid_next_3 = cacheop == 2'b10 ?
				miss_occurred == 1 ?
					miss_way[3] == 1 ? 1 : valids[3]
				: valids[3]
			: valids[3];	

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
				miss_occurred == 1 ?
					miss_way[0] == 1 ? tag_in : tag_raw_out_0	
				: tag_out_0
			   : tag_out_0;

	assign tag_next_1 = cacheop == 2'b10 ?
				miss_occurred == 1 ?
					miss_way[1] == 1 ? tag_in : tag_raw_out_1
				: tag_out_1
			   : tag_out_1;

	assign tag_next_2 = cacheop == 2'b10 ?
				miss_occurred == 1 ?
					miss_way[2] == 1 ? tag_in : tag_raw_out_2
				: tag_out_2
			   : tag_out_2;

	assign tag_next_3 = cacheop == 2'b10 ?
				miss_occurred == 1 ?
					miss_way[3] == 1 ? tag_in : tag_raw_out_3
				: tag_out_3
			   : tag_out_3;

	// LRU Holder
	LRU_SuperFile LRU_FILE(.clk(clk), .rst(rst), .select(set_index), .out_0(lru_w0), .out_1(lru_w1), .out_2(lru_w2), .out_3(lru_w3), .hit_way_1(hit_way_1),
		.hit_way_2(hit_way_2), .hit_way_3(hit_way_3), .hit_way_0(hit_way_0), .hit_occurred(hit_occurred), .miss_occurred(miss_occurred),
		.cache_tag_write(cache_tag_write), .miss_way(miss_way));
	
	// Assign miss ways

	assign miss_way = lru_w0 == 2'b00 ? 4'b0001 :
			  lru_w1 == 2'b00 ? 4'b0010 :
			  lru_w2 == 2'b00 ? 4'b0100 :
			  lru_w3 == 2'b00 ? 4'b1000 :
			  4'b0000;

	assign tag_in_full_0 = {valid_next_0, tag_next_0};
	assign tag_in_full_1 = {valid_next_1, tag_next_1}; 
	assign tag_in_full_2 = {valid_next_2, tag_next_2}; 
	assign tag_in_full_3 = {valid_next_3, tag_next_3}; 

	// Create an admittedly giant decoder, decode block number
	Decoder_5_32 DECODER_DATA(set_index, block_decode);

	// Word decoder
	Decoder_3_8 DECODER_WORD(word_select, ws_one_hot);

	// Cache Arrays
	DataArray CACHE_DATA(.clk(clk), .rst(rst), .DataIn(Data_In), .Write(cache_data_we), .BlockEnable(block_decode_data), .WordEnable(ws_one_hot), .DataOut(DataArray_Out));
	MetaDataArray TAG_ARRAY_WAY_0(.clk(clk), .rst(rst), .DataIn(tag_in_full_0), .Write(cache_tag_we), .BlockEnable(block_decode), .DataOut(tag_raw_out_0));
	MetaDataArray TAG_ARRAY_WAY_1(.clk(clk), .rst(rst), .DataIn(tag_in_full_1), .Write(cache_tag_we), .BlockEnable(block_decode), .DataOut(tag_raw_out_1));	// include way_evict[0] so that on cold misses, only the 0 way writes
	MetaDataArray TAG_ARRAY_WAY_2(.clk(clk), .rst(rst), .DataIn(tag_in_full_2), .Write(cache_tag_we), .BlockEnable(block_decode), .DataOut(tag_raw_out_2));
	MetaDataArray TAG_ARRAY_WAY_3(.clk(clk), .rst(rst), .DataIn(tag_in_full_3), .Write(cache_tag_we), .BlockEnable(block_decode), .DataOut(tag_raw_out_3));

endmodule
