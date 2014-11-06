`timescale 1ns/1ns

`include "async_clib/constants.v"
`include "par_clib/fifo.v"
`include "par_clib/routing_logic_v2.v"
// `include "par_clib/par_rx.v"
// `include "par_clib/par_tx.v"
// `include "par_clib/par_source_traffic.v"
// `include "par_clib/par_source_data.v"
`include "par_clib/par_rx_logic.v"
// `include "par_clib/par_moody_sink.v"
`include "par_clib/routing_table_logic.v"	
`include "par_clib/rr_arbiter.v"
`include "par_clib/ch_rx_logic.v"
`include "par_clib/NI_v1.v"

`include "async_clib/dclk_rx.v"
`include "async_clib/dclk_tx.v"
`include "async_clib/async_router.v"
`include "async_clib/async_generator.v"

	
module testbench(); 

// 	wire reset, clk;
		
	// routers:
	// -----------------------------------------------------------------
	
	wire [`DIRECTIONS-1:0] rx_busy [`NUM_NODES-1:0];
	wire [`DIRECTIONS-2:0] rx_data [`NUM_NODES-1:0];
	wire [`DIRECTIONS-1:0] tx_busy [`NUM_NODES-1:0];
	wire [`DIRECTIONS-2:0] tx_data [`NUM_NODES-1:0];
	
	wire  rx_l_valid [`NUM_NODES-1:0];
	wire  tx_l_valid [`NUM_NODES-1:0];
	wire [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0]  rx_l_data [`NUM_NODES-1:0];
	wire [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0]  tx_l_data [`NUM_NODES-1:0];
	
	wire  router_active [`NUM_NODES-1:0];
	wire [19:0] flit_counter [`NUM_NODES-1:0];
		
// 	clocks 
	wire [`DIRECTIONS-2:0] wclk [`NUM_NODES-1:0];
	wire [`NUM_NODES-1:0] clk ;
	wire [`NUM_NODES-1:0] clk_fw ;	
	
	
	wire [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] source_data [`NUM_NODES-1:0];
	wire source_busy [`NUM_NODES-1:0];
	wire source_valid [`NUM_NODES-1:0];
	
	
	wire [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] sink_data [`NUM_NODES-1:0];
	wire sink_busy [`NUM_NODES-1:0];
	wire sink_valid [`NUM_NODES-1:0];
	
	async_gen g1 (clk, reset, send);


	
	async_router  #(0,"routing_tables/0.txt") 
	  router0 (clk[0], wclk[0], clk_fw[0], reset, rx_busy[0], rx_data[0], rx_l_data[0], rx_l_valid[0], tx_busy[0], tx_data[0], tx_l_data[0], tx_l_valid[0], flit_counter[0]);	
	
	async_router  #(1,"routing_tables/1.txt") 
	  router1 (clk[1], wclk[1], clk_fw[1], reset, rx_busy[1], rx_data[1], rx_l_data[1], rx_l_valid[1], tx_busy[1], tx_data[1], tx_l_data[1], tx_l_valid[1], flit_counter[1]);	
	  
	  
	  NI #(0) NI0 (
			.clk(clk[0]), 
			.reset(reset), 
			.item_out(source_data[0]), 
			.req(source_valid[0]), 
			.channel_busy(source_busy[0]), 
			.send_en(send), 
			.item_in(sink_data[0]), 
			.valid(sink_valid[0]), 
			.busy(sink_busy[0])
		      );
	  
	  NI #(1) NI1 (
			.clk(clk[1]), 
			.reset(reset), 
			.item_out(source_data[1]), 
			.req(source_valid[1]), 
			.channel_busy(source_busy[1]), 
			.send_en(send), 
			.item_in(sink_data[1]), 
			.valid(sink_valid[1]), 
			.busy(sink_busy[1])
		      );
	
	`include "async_clib/create_noc/connections_2nodes.v"
	    
		      
	  
	
endmodule
