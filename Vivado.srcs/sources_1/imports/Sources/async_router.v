

// globally-ascynchronous-locally synchronous router, uses different clocks for each direction.
(* dont_touch = "true" *) module async_router (id,
		     clk,    // local clock
		     wclk, // tx clock from the n, e, s, w
		     clk_fw, // forward clock to rx ports
		     reset, 
		     rx_busy, 
		     rx_data, 
		     rx_l_data, 
		     rx_l_valid, 
		     tx_busy, 
		     tx_data, 
		     tx_l_data, 
		     tx_l_valid,
		     flit_counter);
 	`include "constants.v"
// 	`include "fifo.v"
// 	`include "routing_logic_v2.v"
// 	`include "par_rx_logic.v"
// // 	`include "routing_table.v"	
// // 	`include "rr_arbiter.v"
// 	`include "ch_rx_logic.v"
// // 	`include "NI_v1.v"
// 	`include "dclk_rx.v"
// 	`include "dclk_tx.v"
// // 	`include "async_router.v"

// 	parameter routerid=-1;
	
// 	parameter table_file ="";
	
	// Ports:
	// -----------------------------------------------------------------
	
	// the follow are all bitfield ports with the following format
	// bit 0 : north
	// bit 1 : east
	// bit 2 : south
	// bit 3 : west
	// bit 4 : local
	input [`ADDR_SZ-1:0] id;
	
	output [`DIRECTIONS-1:0] rx_busy;
	input  [`DIRECTIONS-2:0] rx_data;
	input  [`DIRECTIONS-1:0] tx_busy;
	output [`DIRECTIONS-2:0] tx_data;
		
	input [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0]  rx_l_data;  // parallel for local port
	output [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0]  tx_l_data;  

	output  tx_l_valid;
	
	input   rx_l_valid;
	
	assign rx_busy = {rx_l_busy, rx_w_busy,  rx_s_busy, rx_e_busy, rx_n_busy};
	
	assign rx_n_data = rx_data[`NORTH];
	assign rx_e_data = rx_data[`EAST ];
	assign rx_s_data = rx_data[`SOUTH];
	assign rx_w_data = rx_data[`WEST ];
	
	
	assign tx_n_busy = tx_busy[`NORTH];
	assign tx_e_busy = tx_busy[`EAST ];
	assign tx_s_busy = tx_busy[`SOUTH];
	assign tx_w_busy = tx_busy[`WEST ];
	assign tx_l_busy = tx_busy[`LOCAL];
	
	assign tx_data = {tx_w_data, tx_s_data, tx_e_data, tx_n_data};	
	
	// Interface and internal nets:
	// -----------------------------------------------------------------
	
	input clk, reset;
	
	input [`DIRECTIONS-2:0] wclk;
	
	
	output clk_fw;
	
	assign clk_fw = clk;
	
	//output  link_tx_n_data;
	
	
	wire [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] fifo_item_in[`DIRECTIONS-1:0];
	
	wire [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] fifo_item_out[`DIRECTIONS-1:0];
	
	wire [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] item[`DIRECTIONS-1:0];

	wire [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] rr_item_out[`DIRECTIONS-1:0];

	
	wire tx_active [`DIRECTIONS-1:0];
	
	wire read[`DIRECTIONS-1:0]; //  fifo pop signal (routing_logic -> fifo)

	wire item_read[`DIRECTIONS-1:0];  //  Read ack (ch_rx_logic -> rx)
	
	wire write[`DIRECTIONS-1:0];
	
	wire full[`DIRECTIONS-1:0];
	
	wire empty[`DIRECTIONS-1:0];	
	
	wire valid[`DIRECTIONS-1:0];	
	

	output [19:0] flit_counter;
	
	reg [9:0]  sampler;
	reg [19:0] running_flit_counter;
	reg [19:0] flit_counter;
	
	
	// RX :
	// -----------------------------------------------------------------

	
	dclk_rx #("north") rx_n
	(
		.rclk(clk),.wclk(wclk[`NORTH]), .reset(reset),
		.channel_busy(rx_n_busy), .serial_in (rx_n_data),
		.valid(valid[`NORTH]), .parallel_out(item[`NORTH]), .item_read(item_read[`NORTH])
	);
		 
 
	dclk_rx #("east") rx_e
	(
		.rclk(clk),.wclk(wclk[`EAST]), .reset(reset),
		.channel_busy(rx_e_busy), .serial_in (rx_e_data),
		.valid(valid[`EAST]), .parallel_out(item[`EAST]), .item_read(item_read[`EAST])
	);
	
	dclk_rx #("south") rx_s
	(
		.rclk(clk),.wclk(wclk[`SOUTH]), .reset(reset),
		.channel_busy(rx_s_busy), .serial_in (rx_s_data),
		.valid(valid[`SOUTH]), .parallel_out(item[`SOUTH]), .item_read(item_read[`SOUTH])
	);
			 
	
	dclk_rx #("west") rx_w
	(
		.rclk(clk),.wclk(wclk[`WEST]), .reset(reset),
		.channel_busy(rx_w_busy), .serial_in (rx_w_data),
		.valid(valid[`WEST]), .parallel_out(item[`WEST]), .item_read(item_read[`WEST])
	);	
		 
// 	rx #("local") rx_l
// 	(
// 		.clk(clk), .reset(reset),
// 		.channel_busy(rx_l_busy), .serial_in (rx_l_data),
// 		.valid(valid[`LOCAL]), .parallel_out(item[`LOCAL]), .item_read(item_read[`LOCAL])
// 	);		 	 	 		 
// 	
	
	
	

	
	// -----------------------------------------------------------------
	// rx logic for each channel
	// -----------------------------------------------------------------
	
	generate
	genvar channel;
	    for (channel = 0; channel < `DIRECTIONS-1; channel = channel + 1) begin: ch_rx_logics
		ch_rx_logic rx_logic(
			.item_out(fifo_item_in[channel]), .write(write[channel]), .full(full[channel]), 
			.valid(valid[channel]), .item_in(item[channel]), .item_read(item_read[channel])  
		);
	    end
	
	 // parallel for local port
	 par_rx_logic rx_l(.item_out(fifo_item_in[`LOCAL]), .write(write[`LOCAL]), .full(full[`LOCAL]), 
			.valid(rx_l_valid), .item_in(rx_l_data), .item_read(item_read[`LOCAL]), .busy(rx_l_busy)
		);
		
		
	// -----------------------------------------------------------------
	// rx fifo for each channel
	// -----------------------------------------------------------------
	

	    for (channel = 0; channel < `DIRECTIONS; channel = channel + 1) begin: fifos
		  fifo  myfifo(
		  
			.clk(clk), .reset(reset),
			.full(full[channel]), .empty(empty[channel]),
			.item_in(fifo_item_in[channel]), .item_out(fifo_item_out[channel]),
			.write (write[channel]), .read(read[channel])
		  
		  );	    
	    end
	endgenerate
	
	

//        routing_logic #(routerid,table_file) rr_routing_logic(
       routing_logic routing_logic0 (
		.id(id), .clk(clk), .reset(reset),
		.n_item_in(fifo_item_out[`NORTH]), .n_read(read[`NORTH]), .n_empty(empty[`NORTH]), .n_item_out(rr_item_out[`NORTH]), .n_ena(n_ena), .n_busy(n_busy),
		.e_item_in(fifo_item_out[`EAST ]), .e_read(read[`EAST ]), .e_empty(empty[`EAST ]), .e_item_out(rr_item_out[`EAST ]), .e_ena(e_ena), .e_busy(e_busy),
		.s_item_in(fifo_item_out[`SOUTH]), .s_read(read[`SOUTH]), .s_empty(empty[`SOUTH]), .s_item_out(rr_item_out[`SOUTH]), .s_ena(s_ena), .s_busy(s_busy),
		.w_item_in(fifo_item_out[`WEST ]), .w_read(read[`WEST ]), .w_empty(empty[`WEST ]), .w_item_out(rr_item_out[`WEST ]), .w_ena(w_ena), .w_busy(w_busy),
		.l_item_in(fifo_item_out[`LOCAL]), .l_read(read[`LOCAL]), .l_empty(empty[`LOCAL]), .l_item_out(tx_l_data), .l_ena(tx_l_valid), .l_busy(tx_l_busy)
		);
		
			
	// TX :
	// -----------------------------------------------------------------	
	
	dclk_tx #("north") tx_n
	(
		.clk(clk), .reset(reset), .tx_active(tx_active[`NORTH]),
		.req(n_ena), .tx_busy(n_busy),
		.channel_busy(tx_n_busy), .serial_out(tx_n_data),
		.parallel_in(rr_item_out[`NORTH])
	);
	

	dclk_tx #("east") tx_e
	(
		.clk(clk), .reset(reset),.tx_active(tx_active[`EAST]),
		.req(e_ena), .tx_busy(e_busy),
		.channel_busy(tx_e_busy), .serial_out(tx_e_data),
		.parallel_in(rr_item_out[`EAST])
	);
	
	dclk_tx #("south") tx_s
	(
		.clk(clk), .reset(reset),.tx_active(tx_active[`SOUTH]),
		.req(s_ena), .tx_busy(s_busy),
		.channel_busy(tx_s_busy), .serial_out(tx_s_data),
		.parallel_in(rr_item_out[`SOUTH])
	);
	
	dclk_tx #("west") tx_w
	(
		.clk(clk), .reset(reset), .tx_active(tx_active[`WEST]),
		.req(w_ena), .tx_busy(w_busy),
		.channel_busy(tx_w_busy), .serial_out(tx_w_data),
		.parallel_in(rr_item_out[`WEST])
	);
	
	
	
	
// Router activity :
	wire [2:0] written_flits;
	
	assign written_flits=(write[`NORTH]+write[`EAST]+write[`SOUTH]+write[`WEST]+write[`LOCAL]);
	
	
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
				running_flit_counter <= running_flit_counter + (written_flits);
				
				sampler <=sampler+1;
			end //!sampler
		end //!reset


	end // always

endmodule
