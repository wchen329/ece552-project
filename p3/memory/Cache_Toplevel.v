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
 * tag	   set	   byte offset
 *
 * Furthermore, each tag array block has 8 bit buses. The tag array block is
 * partitioned as follows:
 *
 * [ 1 ]   [ 1 ]   [ 6 ]
 * valid   lru     tag
 * -
 *
 * lru == 1 ? (least recently used) : (not most recently used);
 *
 * wchen329@wisc.edu
 */
module Cache_Toplevel(clk, rst, Address_Oper, store, r_enabled, cacheop, Data_In, Data_Out, miss_occurred);

	input clk;			// Clock signal
	input rst;			// reset signal
	input [15:0] Address_Oper;	// address to perform memory operation
	input [15:0] Data_In;		// input data to be used in case of a store
	input store;			// true if store, false if load
	input r_enabled;		// true if operation is memory operation, false if not memory operation
	input [1:0] cacheop;		// encoded control signals for FSM to perform operations on caches. 0 = read, 1 = fill, 2 = set cache tag, 3 = X

	output miss_occurred;
	output [15:0] Data_Out;		// output data in case of load

	wire cc_valid;			// current cycle request is valid?
	wire [127:0] block_decode;	// the block to get or store to
	wire [7:0] word_select;		// the word within the block to retrieve
	wire [7:0] tag_in;		// tag to update the cache with
	wire [7:0] tag_out;		// tag that is read
	wire cache_data_we;		// data write enable, passed from Fill FSM
	wire cache_tag_we;		// tag write enable, passed from Fill FSM
	wire [15:0] DataArray_Out;	// raw data leaving cache array

	/* Evaluate cache miss signal
	 * In order to evaluate the miss signal, "speculate" cache hit first,
	 * meaning read from data and tag in the same cycle. This will allow
	 * for a tag comparison in the same cycle. If it happens to be a miss,
	 * just disable the read and raise the cache_stall / miss signal.
	 */

	// Assign wire signals
	assign miss_occurred = (~cc_valid & (tag_in != tag_out)); // a miss if the read tag is different from tag to write
	assign Data_Out = {15{~miss_occurred}} & DataArray_Out; // a miss makes the data out NULL
	assign cache_data_we = Cacheop == 2'b01 ? 1 : 0; 
	assign cache_tag_we = Cacheop == 2'b10 ? 1 : 0;

	// Create an admittedly giant decoder


	// Cache Arrays
	DataArray CACHE_DATA(.clk(clk), .rst(rst), .DataIn(Data_In), .Write(cache_data_we), .BlockEnable(block_decode), .WordEnable(word_select) .DataOut(DataArray_Out));
	MetaDataArray TAG_ARRAY(.clk(clk), .rst(rst), .DataIn(tag_in), .Write(cache_tag_we), .BlockEnable(block_decode), .DataOut(tag_out));

endmodule
