/* A toplevel for the cache that connects to the cpu toplevel
 * The L1 Cache Toplevel encapsulated a L1 Cache Data Array and Tag Array 
 * and connects to the Main Memory task arbritrator in the event of a single
 * read port of the data memory directly in the event of two read ports.
 * Also includes fill FSM.
 *
 * -
 *
 * wchen329@wisc.edu
 */
module L1_Cache_Toplevel(clk, rst, Address_Oper, store, idle, Data_In, miss_state, Data_Out, cache_stall);

	input clk;			// Clock signal
	input rst;			// reset signal
	input [15:0] Address_Oper;	// address to perform memory operation
	input [15:0] Data_In;		// input data to be used in case of a store
	input store;			// true if store, false if load
	input idle;			// true if operation is not memory operation, false if memory operation

	output miss_state;		// cache is busy handling miss
	output cache_stall;		// cache "busy filling" signal
	output [15:0] Data_Out;		// output data in case of load

	wire [127:0] block_decode;	// the block to get or store to
	wire [7:0] word_select;		// the word within the block to retrieve
	wire [7:0] tag_in;		// tag to update the cache with
	wire [7:0] tag_out;		// tag that is read
	wire cache_data_we;		// data write enable, passed from Fill FSM
	wire cache_tag_we;		// tag write enable, passed from Fill FSM

	/* Evaluate cache miss signal
	 * In order to evaluate the miss signal, "speculate" cache hit first,
	 * meaning read from data and tag in the same cycle. This will allow
	 * for a tag comparison in the same cycle. If it happens to be a miss,
	 * just disable the read and raise the cache_stall / miss signal.
	 */

	// Assign wire signals

	// Cache Arrays
	DataArray CACHE_DATA(.clk(clk), .rst(rst), .DataIn(Data_In), .Write(cache_data_we), .BlockEnable(block_decode), .WordEnable(word_select) .DataOut(Data_Out));
	MetaDataArray TAG_ARRAY(.clk(clk), .rst(rst), .DataIn(tag_in), .Write(cache_tag_we), .BlockEnable(block_decode), .DataOut(tag_out));

endmodule