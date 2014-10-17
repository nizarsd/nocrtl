module router (clk, reset, rx_busy, rx_data, tx_busy, tx_data, table_addr, table_data, flit_counter);

	parameter routerid = -1;

	// Ports:
	// -----------------------------------------------------------------
	
	// the follow are all bitfield ports with the following format
	// bit 0 : north
	// bit 1 : east
	// bit 2 : south
	// bit 3 : west
	// bit 4 : local
	
	output [`DIRECTIONS-1:0] rx_busy;
	input  [`DIRECTIONS-1:0] rx_data;
	input  [`DIRECTIONS-1:0] tx_busy;
	output [`DIRECTIONS-1:0] tx_data;
	
	assign rx_busy = {rx_l_busy, rx_w_busy,  rx_s_busy, rx_e_busy, rx_n_busy};
	
	assign rx_l_data = rx_data[4];
	assign rx_w_data = rx_data[3];
	assign rx_s_data = rx_data[2];
	assign rx_e_data = rx_data[1];
	assign rx_n_data = rx_data[0];
	
	assign tx_l_busy = tx_busy[4];
	assign tx_w_busy = tx_busy[3];
	assign tx_s_busy = tx_busy[2];
	assign tx_e_busy = tx_busy[1];
	assign tx_n_busy = tx_busy[0];
	
	assign tx_data = {tx_l_data, tx_w_data, tx_s_data, tx_e_data, tx_n_data};	
	
	// Interface and internal nets:
	// -----------------------------------------------------------------
	
	input clk, reset;
	
	//output  link_tx_n_data;
	
	output [`ADDR_BITS-1:0] table_addr;
	
	input [`BITS_DIR-1:0] table_data;
	
	//wire full, empty;	

	wire [`PAYLOAD_SIZE+`ADDR_BITS-1:0] fifo_item_in;
	
	wire [`PAYLOAD_SIZE+`ADDR_BITS-1:0] fifo_item_out;
	
	wire [`PAYLOAD_SIZE+`ADDR_BITS-1:0] tx_item_out;

	wire read, write;
	
	output [19:0] flit_counter;
	
	reg [9:0] sampler;
	reg [19:0] running_flit_counter;
	reg [19:0] flit_counter;
	
	
	// RX :
	// -----------------------------------------------------------------
	
	wire [`PAYLOAD_SIZE+`ADDR_BITS-1:0] n_item;
	wire [`PAYLOAD_SIZE+`ADDR_BITS-1:0] s_item;
	wire [`PAYLOAD_SIZE+`ADDR_BITS-1:0] e_item;
	wire [`PAYLOAD_SIZE+`ADDR_BITS-1:0] w_item;
	wire [`PAYLOAD_SIZE+`ADDR_BITS-1:0] l_item;	
	wire tx_active [`DIRECTIONS-1:0];
	
	rx #(routerid,"north") rx_n
	(
		.clk(clk), .reset(reset),
		.channel_busy(rx_n_busy), .serial_in (rx_n_data),
		.valid(n_valid), .parallel_out(n_item), .item_read(n_read)
	);
		 
 
	rx #(routerid,"east") rx_e
	(
		.clk(clk), .reset(reset),
		.channel_busy(rx_e_busy), .serial_in (rx_e_data),
		.valid(e_valid), .parallel_out(e_item), .item_read(e_read)
	);
	
	rx #(routerid,"south") rx_s
	(
		.clk(clk), .reset(reset),
		.channel_busy(rx_s_busy), .serial_in (rx_s_data),
		.valid(s_valid), .parallel_out(s_item), .item_read(s_read)
	);
			 
	
	rx #(routerid,"west") rx_w
	(
		.clk(clk), .reset(reset),
		.channel_busy(rx_w_busy), .serial_in (rx_w_data),
		.valid(w_valid), .parallel_out(w_item), .item_read(w_read)
	);	
		 
	rx #(routerid,"local") rx_l
	(
		.clk(clk), .reset(reset),
		.channel_busy(rx_l_busy), .serial_in (rx_l_data),
		.valid(l_valid), .parallel_out(l_item), .item_read(l_read)
	);		 	 	 		 
	
	rx_logic rx_logic1
	(
		.item_out(fifo_item_in), .write(write), .full(full), 
		.n_valid(n_valid), .n_item(n_item), .n_read(n_read),  
		.s_valid(s_valid), .s_item(s_item), .s_read(s_read),  
		.e_valid(e_valid), .e_item(e_item), .e_read(e_read), 
		.w_valid(w_valid), .w_item(w_item), .w_read(w_read), 
		.l_valid(l_valid), .l_item(l_item), .l_read(l_read)
	);
	
	// -----------------------------------------------------------------
	
	fifo #(routerid) myfifo1
	(
		.clk(clk), .reset(reset),
		.full(full), .empty(empty),
		.item_in(fifo_item_in), .item_out(fifo_item_out),
		.write (write), .read(read)
	);
	
	// TX :
	// -----------------------------------------------------------------	
	
	//wire n_ena, n_busy, s_ena, s_busy, e_ena, e_busy, w_ena, w_busy, l_ena, l_busy;
	
	tx_logic tx_logic1 
	(
		.item_in(fifo_item_out), .read(read), .empty(empty),
		.table_addr(table_addr), .table_data(table_data),
		.item_out(tx_item_out),
		.n_ena(n_ena), .n_busy(n_busy),
		.s_ena(s_ena), .s_busy(s_busy),
		.e_ena(e_ena), .e_busy(e_busy),
		.w_ena(w_ena), .w_busy(w_busy),
		.l_ena(l_ena), .l_busy(l_busy)
	);
	
	tx #(routerid,"north") tx_n
	(
		.clk(clk), .reset(reset), .tx_active(tx_active[0]),
		.req(n_ena), .tx_busy(n_busy),
		.channel_busy(tx_n_busy), .serial_out(tx_n_data),
		.parallel_in(fifo_item_out)
	);
	

	tx #(routerid,"east") tx_e
	(
		.clk(clk), .reset(reset),.tx_active(tx_active[1]),
		.req(e_ena), .tx_busy(e_busy),
		.channel_busy(tx_e_busy), .serial_out(tx_e_data),
		.parallel_in(fifo_item_out)
	);
	
	tx #(routerid,"south") tx_s
	(
		.clk(clk), .reset(reset),.tx_active(tx_active[2]),
		.req(s_ena), .tx_busy(s_busy),
		.channel_busy(tx_s_busy), .serial_out(tx_s_data),
		.parallel_in(fifo_item_out)
	);
	
	tx #(routerid,"west") tx_w
	(
		.clk(clk), .reset(reset), .tx_active(tx_active[3]),
		.req(w_ena), .tx_busy(w_busy),
		.channel_busy(tx_w_busy), .serial_out(tx_w_data),
		.parallel_in(fifo_item_out)
	);
	
	tx #(routerid,"local") tx_l_read
	(
		.clk(clk), .reset(reset),
		.req(l_ena), .tx_busy(l_busy),.tx_active(tx_active[4]),
		.channel_busy(tx_l_busy), .serial_out(tx_l_data),
		.parallel_in(fifo_item_out)
	);
	
// Router activity :
	
	
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			sampler <= 0;
			running_flit_counter <= 0;
			flit_counter <= 0;
		end 
		else begin
			if (&(sampler))
			begin
				flit_counter <= running_flit_counter;

				running_flit_counter <= 0;
				
				sampler <= 0;
			end   //sampler
			else begin
				running_flit_counter <= running_flit_counter + (write);
				
				sampler <=sampler+1;
			end //!sampler
		end //!reset


	end // always

endmodule
