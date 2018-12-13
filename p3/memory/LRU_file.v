/* Holds a collection of LRU files for each set.
 *
 * wchen329@wisc.edu
 */
module LRU_SuperFile(clk, rst, select, out_0, out_1, out_2, out_3, hit_way_1, hit_way_2, hit_way_3, hit_way_0, hit_occurred, miss_occurred, cache_tag_write, miss_way);

	input clk, rst, hit_way_1, hit_way_2, hit_way_3, hit_way_0, hit_occurred, miss_occurred, cache_tag_write;
	input [3:0] miss_way;
	input [4:0] select;
	output [1:0] out_0, out_1, out_2, out_3;

	LRU_File FILE_0(.clk(clk), .rst(rst), .miss_way(miss_way), .out_0(out_0), .out_1(out_1), .out_2(out_2), .out_3(out_3),
		.hit_way_1(hit_way_1), .hit_way_2(hit_way_2), .hit_way_3(hit_way_3), .hit_way_0(hit_way_0), .hit_occurred(hit_occurred), .miss_occurred(miss_occurred),
		.cache_tag_write(cache_tag_write), .r_active(select==5'b00000));
	LRU_File FILE_1(.clk(clk), .rst(rst), .miss_way(miss_way), .out_0(out_0), .out_1(out_1), .out_2(out_2), .out_3(out_3),
		.hit_way_1(hit_way_1), .hit_way_2(hit_way_2), .hit_way_3(hit_way_3), .hit_way_0(hit_way_0), .hit_occurred(hit_occurred), .miss_occurred(miss_occurred),
		.cache_tag_write(cache_tag_write), .r_active(select==5'b00001));
	LRU_File FILE_2(.clk(clk), .rst(rst), .miss_way(miss_way), .out_0(out_0), .out_1(out_1), .out_2(out_2), .out_3(out_3),
		.hit_way_1(hit_way_1), .hit_way_2(hit_way_2), .hit_way_3(hit_way_3), .hit_way_0(hit_way_0), .hit_occurred(hit_occurred), .miss_occurred(miss_occurred),
		.cache_tag_write(cache_tag_write), .r_active(select==5'b00010));
	LRU_File FILE_3(.clk(clk), .rst(rst), .miss_way(miss_way), .out_0(out_0), .out_1(out_1), .out_2(out_2), .out_3(out_3),
		.hit_way_1(hit_way_1), .hit_way_2(hit_way_2), .hit_way_3(hit_way_3), .hit_way_0(hit_way_0), .hit_occurred(hit_occurred), .miss_occurred(miss_occurred),
		.cache_tag_write(cache_tag_write), .r_active(select==5'b00011));
	LRU_File FILE_4(.clk(clk), .rst(rst), .miss_way(miss_way), .out_0(out_0), .out_1(out_1), .out_2(out_2), .out_3(out_3),
		.hit_way_1(hit_way_1), .hit_way_2(hit_way_2), .hit_way_3(hit_way_3), .hit_way_0(hit_way_0), .hit_occurred(hit_occurred), .miss_occurred(miss_occurred),
		.cache_tag_write(cache_tag_write), .r_active(select==5'b00100));
	LRU_File FILE_5(.clk(clk), .rst(rst), .miss_way(miss_way), .out_0(out_0), .out_1(out_1), .out_2(out_2), .out_3(out_3),
		.hit_way_1(hit_way_1), .hit_way_2(hit_way_2), .hit_way_3(hit_way_3), .hit_way_0(hit_way_0), .hit_occurred(hit_occurred), .miss_occurred(miss_occurred),
		.cache_tag_write(cache_tag_write), .r_active(select==5'b00101));
	LRU_File FILE_6(.clk(clk), .rst(rst), .miss_way(miss_way), .out_0(out_0), .out_1(out_1), .out_2(out_2), .out_3(out_3),
		.hit_way_1(hit_way_1), .hit_way_2(hit_way_2), .hit_way_3(hit_way_3), .hit_way_0(hit_way_0), .hit_occurred(hit_occurred), .miss_occurred(miss_occurred),
		.cache_tag_write(cache_tag_write), .r_active(select==5'b00110));
	LRU_File FILE_7(.clk(clk), .rst(rst), .miss_way(miss_way), .out_0(out_0), .out_1(out_1), .out_2(out_2), .out_3(out_3),
		.hit_way_1(hit_way_1), .hit_way_2(hit_way_2), .hit_way_3(hit_way_3), .hit_way_0(hit_way_0), .hit_occurred(hit_occurred), .miss_occurred(miss_occurred),
		.cache_tag_write(cache_tag_write), .r_active(select==5'b00111));
	LRU_File FILE_8(.clk(clk), .rst(rst), .miss_way(miss_way), .out_0(out_0), .out_1(out_1), .out_2(out_2), .out_3(out_3),
		.hit_way_1(hit_way_1), .hit_way_2(hit_way_2), .hit_way_3(hit_way_3), .hit_way_0(hit_way_0), .hit_occurred(hit_occurred), .miss_occurred(miss_occurred),
		.cache_tag_write(cache_tag_write), .r_active(select==5'b01000));
	LRU_File FILE_9(.clk(clk), .rst(rst), .miss_way(miss_way), .out_0(out_0), .out_1(out_1), .out_2(out_2), .out_3(out_3),
		.hit_way_1(hit_way_1), .hit_way_2(hit_way_2), .hit_way_3(hit_way_3), .hit_way_0(hit_way_0), .hit_occurred(hit_occurred), .miss_occurred(miss_occurred),
		.cache_tag_write(cache_tag_write), .r_active(select==5'b01001));
	LRU_File FILE_10(.clk(clk), .rst(rst), .miss_way(miss_way), .out_0(out_0), .out_1(out_1), .out_2(out_2), .out_3(out_3),
		.hit_way_1(hit_way_1), .hit_way_2(hit_way_2), .hit_way_3(hit_way_3), .hit_way_0(hit_way_0), .hit_occurred(hit_occurred), .miss_occurred(miss_occurred),
		.cache_tag_write(cache_tag_write), .r_active(select==5'b01010));
	LRU_File FILE_11(.clk(clk), .rst(rst), .miss_way(miss_way), .out_0(out_0), .out_1(out_1), .out_2(out_2), .out_3(out_3),
		.hit_way_1(hit_way_1), .hit_way_2(hit_way_2), .hit_way_3(hit_way_3), .hit_way_0(hit_way_0), .hit_occurred(hit_occurred), .miss_occurred(miss_occurred),
		.cache_tag_write(cache_tag_write), .r_active(select==5'b01011));
	LRU_File FILE_12(.clk(clk), .rst(rst), .miss_way(miss_way), .out_0(out_0), .out_1(out_1), .out_2(out_2), .out_3(out_3),
		.hit_way_1(hit_way_1), .hit_way_2(hit_way_2), .hit_way_3(hit_way_3), .hit_way_0(hit_way_0), .hit_occurred(hit_occurred), .miss_occurred(miss_occurred),
		.cache_tag_write(cache_tag_write), .r_active(select==5'b01100));
	LRU_File FILE_13(.clk(clk), .rst(rst), .miss_way(miss_way), .out_0(out_0), .out_1(out_1), .out_2(out_2), .out_3(out_3),
		.hit_way_1(hit_way_1), .hit_way_2(hit_way_2), .hit_way_3(hit_way_3), .hit_way_0(hit_way_0), .hit_occurred(hit_occurred), .miss_occurred(miss_occurred),
		.cache_tag_write(cache_tag_write), .r_active(select==5'b01101));
	LRU_File FILE_14(.clk(clk), .rst(rst), .miss_way(miss_way), .out_0(out_0), .out_1(out_1), .out_2(out_2), .out_3(out_3),
		.hit_way_1(hit_way_1), .hit_way_2(hit_way_2), .hit_way_3(hit_way_3), .hit_way_0(hit_way_0), .hit_occurred(hit_occurred), .miss_occurred(miss_occurred),
		.cache_tag_write(cache_tag_write), .r_active(select==5'b01110));
	LRU_File FILE_15(.clk(clk), .rst(rst), .miss_way(miss_way), .out_0(out_0), .out_1(out_1), .out_2(out_2), .out_3(out_3),
		.hit_way_1(hit_way_1), .hit_way_2(hit_way_2), .hit_way_3(hit_way_3), .hit_way_0(hit_way_0), .hit_occurred(hit_occurred), .miss_occurred(miss_occurred),
		.cache_tag_write(cache_tag_write), .r_active(select==5'b01111));
	LRU_File FILE_16(.clk(clk), .rst(rst), .miss_way(miss_way), .out_0(out_0), .out_1(out_1), .out_2(out_2), .out_3(out_3),
		.hit_way_1(hit_way_1), .hit_way_2(hit_way_2), .hit_way_3(hit_way_3), .hit_way_0(hit_way_0), .hit_occurred(hit_occurred), .miss_occurred(miss_occurred),
		.cache_tag_write(cache_tag_write), .r_active(select==5'b10000));
	LRU_File FILE_17(.clk(clk), .rst(rst), .miss_way(miss_way), .out_0(out_0), .out_1(out_1), .out_2(out_2), .out_3(out_3),
		.hit_way_1(hit_way_1), .hit_way_2(hit_way_2), .hit_way_3(hit_way_3), .hit_way_0(hit_way_0), .hit_occurred(hit_occurred), .miss_occurred(miss_occurred),
		.cache_tag_write(cache_tag_write), .r_active(select==5'b10001));
	LRU_File FILE_18(.clk(clk), .rst(rst), .miss_way(miss_way), .out_0(out_0), .out_1(out_1), .out_2(out_2), .out_3(out_3),
		.hit_way_1(hit_way_1), .hit_way_2(hit_way_2), .hit_way_3(hit_way_3), .hit_way_0(hit_way_0), .hit_occurred(hit_occurred), .miss_occurred(miss_occurred),
		.cache_tag_write(cache_tag_write), .r_active(select==5'b10010));
	LRU_File FILE_19(.clk(clk), .rst(rst), .miss_way(miss_way), .out_0(out_0), .out_1(out_1), .out_2(out_2), .out_3(out_3),
		.hit_way_1(hit_way_1), .hit_way_2(hit_way_2), .hit_way_3(hit_way_3), .hit_way_0(hit_way_0), .hit_occurred(hit_occurred), .miss_occurred(miss_occurred),
		.cache_tag_write(cache_tag_write), .r_active(select==5'b10011));
	LRU_File FILE_20(.clk(clk), .rst(rst), .miss_way(miss_way), .out_0(out_0), .out_1(out_1), .out_2(out_2), .out_3(out_3),
		.hit_way_1(hit_way_1), .hit_way_2(hit_way_2), .hit_way_3(hit_way_3), .hit_way_0(hit_way_0), .hit_occurred(hit_occurred), .miss_occurred(miss_occurred),
		.cache_tag_write(cache_tag_write), .r_active(select==5'b10100));
	LRU_File FILE_21(.clk(clk), .rst(rst), .miss_way(miss_way), .out_0(out_0), .out_1(out_1), .out_2(out_2), .out_3(out_3),
		.hit_way_1(hit_way_1), .hit_way_2(hit_way_2), .hit_way_3(hit_way_3), .hit_way_0(hit_way_0), .hit_occurred(hit_occurred), .miss_occurred(miss_occurred),
		.cache_tag_write(cache_tag_write), .r_active(select==5'b10101));
	LRU_File FILE_22(.clk(clk), .rst(rst), .miss_way(miss_way), .out_0(out_0), .out_1(out_1), .out_2(out_2), .out_3(out_3),
		.hit_way_1(hit_way_1), .hit_way_2(hit_way_2), .hit_way_3(hit_way_3), .hit_way_0(hit_way_0), .hit_occurred(hit_occurred), .miss_occurred(miss_occurred),
		.cache_tag_write(cache_tag_write), .r_active(select==5'b10110));
	LRU_File FILE_23(.clk(clk), .rst(rst), .miss_way(miss_way), .out_0(out_0), .out_1(out_1), .out_2(out_2), .out_3(out_3),
		.hit_way_1(hit_way_1), .hit_way_2(hit_way_2), .hit_way_3(hit_way_3), .hit_way_0(hit_way_0), .hit_occurred(hit_occurred), .miss_occurred(miss_occurred),
		.cache_tag_write(cache_tag_write), .r_active(select==5'b10111));
	LRU_File FILE_24(.clk(clk), .rst(rst), .miss_way(miss_way), .out_0(out_0), .out_1(out_1), .out_2(out_2), .out_3(out_3),
		.hit_way_1(hit_way_1), .hit_way_2(hit_way_2), .hit_way_3(hit_way_3), .hit_way_0(hit_way_0), .hit_occurred(hit_occurred), .miss_occurred(miss_occurred),
		.cache_tag_write(cache_tag_write), .r_active(select==5'b11000));
	LRU_File FILE_25(.clk(clk), .rst(rst), .miss_way(miss_way), .out_0(out_0), .out_1(out_1), .out_2(out_2), .out_3(out_3),
		.hit_way_1(hit_way_1), .hit_way_2(hit_way_2), .hit_way_3(hit_way_3), .hit_way_0(hit_way_0), .hit_occurred(hit_occurred), .miss_occurred(miss_occurred),
		.cache_tag_write(cache_tag_write), .r_active(select==5'b11001));
	LRU_File FILE_26(.clk(clk), .rst(rst), .miss_way(miss_way), .out_0(out_0), .out_1(out_1), .out_2(out_2), .out_3(out_3),
		.hit_way_1(hit_way_1), .hit_way_2(hit_way_2), .hit_way_3(hit_way_3), .hit_way_0(hit_way_0), .hit_occurred(hit_occurred), .miss_occurred(miss_occurred),
		.cache_tag_write(cache_tag_write), .r_active(select==5'b11010));
	LRU_File FILE_27(.clk(clk), .rst(rst), .miss_way(miss_way), .out_0(out_0), .out_1(out_1), .out_2(out_2), .out_3(out_3),
		.hit_way_1(hit_way_1), .hit_way_2(hit_way_2), .hit_way_3(hit_way_3), .hit_way_0(hit_way_0), .hit_occurred(hit_occurred), .miss_occurred(miss_occurred),
		.cache_tag_write(cache_tag_write), .r_active(select==5'b11011));
	LRU_File FILE_28(.clk(clk), .rst(rst), .miss_way(miss_way), .out_0(out_0), .out_1(out_1), .out_2(out_2), .out_3(out_3),
		.hit_way_1(hit_way_1), .hit_way_2(hit_way_2), .hit_way_3(hit_way_3), .hit_way_0(hit_way_0), .hit_occurred(hit_occurred), .miss_occurred(miss_occurred),
		.cache_tag_write(cache_tag_write), .r_active(select==5'b11100));
	LRU_File FILE_29(.clk(clk), .rst(rst), .miss_way(miss_way), .out_0(out_0), .out_1(out_1), .out_2(out_2), .out_3(out_3),
		.hit_way_1(hit_way_1), .hit_way_2(hit_way_2), .hit_way_3(hit_way_3), .hit_way_0(hit_way_0), .hit_occurred(hit_occurred), .miss_occurred(miss_occurred),
		.cache_tag_write(cache_tag_write), .r_active(select==5'b11101));
	LRU_File FILE_30(.clk(clk), .rst(rst), .miss_way(miss_way), .out_0(out_0), .out_1(out_1), .out_2(out_2), .out_3(out_3),
		.hit_way_1(hit_way_1), .hit_way_2(hit_way_2), .hit_way_3(hit_way_3), .hit_way_0(hit_way_0), .hit_occurred(hit_occurred), .miss_occurred(miss_occurred),
		.cache_tag_write(cache_tag_write), .r_active(select==5'b11110));
	LRU_File FILE_31(.clk(clk), .rst(rst), .miss_way(miss_way), .out_0(out_0), .out_1(out_1), .out_2(out_2), .out_3(out_3),
		.hit_way_1(hit_way_1), .hit_way_2(hit_way_2), .hit_way_3(hit_way_3), .hit_way_0(hit_way_0), .hit_occurred(hit_occurred), .miss_occurred(miss_occurred),
		.cache_tag_write(cache_tag_write), .r_active(select==5'b11111));
endmodule

/* Holds LRU information for each cache block in a set.
 *
 * wchen329@wisc.edu
 */
module LRU_File(clk, rst, miss_way, r_active, out_0, out_1, out_2, out_3, hit_way_1, hit_way_2, hit_way_3, hit_way_0, hit_occurred, miss_occurred, cache_tag_write);

	input [3:0] miss_way;
	input clk, rst, r_active, hit_way_1, hit_way_2, hit_way_3, hit_way_0, hit_occurred, miss_occurred;
	input cache_tag_write;
	output [1:0] out_0, out_1, out_2, out_3;

	// LRU Registers
	reg [1:0] lru_w0, lru_w1, lru_w2, lru_w3;

	assign out_0 = r_active ? lru_w0 : {2{1'bz}};
	assign out_1 = r_active ? lru_w1 : {2{1'bz}};
	assign out_2 = r_active ? lru_w2 : {2{1'bz}};
	assign out_3 = r_active ? lru_w3 : {2{1'bz}};

	// New LRU using better Verilog
	// Register behavior for new LRU
	always @(posedge clk) begin

		if(rst == 1) begin
			lru_w0 <= 2'b00;
			lru_w1 <= 2'b00;
			lru_w2 <= 2'b00;
			lru_w3 <= 2'b00;
		end

		/* LRU
		 * -
		 * When to update?
		 *
		 * HIT - Always update. Set hit way to 2'b11 decrement others.
		 * MISS - Always update. Set evicted missed way to 2'b11 and decrement others. Write simultaneously with tag.
		 *
		 */
		if(cache_tag_write) begin
			if(lru_w0 != 2'b00 && miss_way != 4'b0001) begin
				lru_w0 <= (lru_w0 - 1);
			end
			if(lru_w1 != 2'b00 && miss_way != 4'b0010) begin
				lru_w1 <= (lru_w1 - 1);
			end
			if(lru_w2 != 2'b00 && miss_way != 4'b0100) begin
				lru_w2 <= (lru_w2 - 1);
			end
			if(lru_w3 != 2'b00 && miss_way != 4'b1000) begin
				lru_w3 <= (lru_w3 - 1);
			end

			if(lru_w0 == 2'b00 && miss_way == 4'b0001) begin
				lru_w0 <= 2'b11;
			end
			if(lru_w1 == 2'b00 && miss_way == 4'b0010) begin
				lru_w1 <= 2'b11;
			end
			if(lru_w2 == 2'b00 && miss_way == 4'b0100) begin
				lru_w2 <= 2'b11;
			end
			if(lru_w3 == 2'b00 && miss_way == 4'b1000) begin
				lru_w3 <= 2'b11;
			end
		end

		if(hit_occurred && !miss_occurred) begin
			if(hit_way_0) begin
							lru_w0 <= 2'b11;
				if(lru_w1 != 2'b00) lru_w1 <= (lru_w1 - 1);
				if(lru_w2 != 2'b00) lru_w2 <= (lru_w2 - 1);
				if(lru_w3 != 2'b00) lru_w3 <= (lru_w3 - 1);
			end
			if(hit_way_1) begin
				if(lru_w0 != 2'b00) lru_w0 <= (lru_w0 - 1);
							lru_w1 <= 2'b11;
				if(lru_w2 != 2'b00) lru_w2 <= (lru_w2 - 1);
				if(lru_w3 != 2'b00) lru_w3 <= (lru_w3 - 1);
			end
			if(hit_way_2) begin
				if(lru_w0 != 2'b00) lru_w0 <= (lru_w0 - 1);
				if(lru_w1 != 2'b00) lru_w1 <= (lru_w1 - 1);
							lru_w2 <= 2'b11;
				if(lru_w3 != 2'b00) lru_w3 <= (lru_w3 - 1);
			end
			if(hit_way_3) begin
				if(lru_w0 != 2'b00) lru_w0 <= (lru_w0 - 1);
				if(lru_w1 != 2'b00) lru_w1 <= (lru_w1 - 1);
				if(lru_w2 != 2'b00) lru_w2 <= (lru_w2 - 1);
							lru_w3 <= 2'b11;
			end
		end

	end


endmodule
