`timescale 1ns/1ns

`include "constants.v"
`include "../par_clib/fifo.v"
`include "../par_clib/routing_logic_v2.v"
// `include "par_clib/par_rx.v"
// `include "par_clib/par_tx.v"
// `include "par_clib/par_source_traffic.v"
// `include "par_clib/par_source_data.v"
`include "../par_clib/par_rx_logic.v"
// `include "par_clib/par_moody_sink.v"
`include "../par_clib/routing_table.v"	
`include "../par_clib/rr_arbiter.v"
`include "../par_clib/ch_rx_logic.v"
`include "../par_clib/NI_v1.v"

`include "dclk_rx.v"
`include "dclk_tx.v"
`include "async_router.v"
// `include "async_generator.v"

	
module node_wrapper(
		    id,
		    reset, 
		    en,
		    clk, 
		    
    		    txclk_n,
		    txclk_e,
		    txclk_s,
		    txclk_w,

		    wclk_n,
		    wclk_e,
		    wclk_s,
		    wclk_w,
		    
		    rx_busy_n, 
		    rx_busy_e, 
		    rx_busy_s, 
		    rx_busy_w, 
		    
		    rx_data_n, 
		    rx_data_e, 
		    rx_data_s, 
		    rx_data_w, 
		    
		    tx_busy_n, 
		    tx_busy_e, 
		    tx_busy_s, 
		    tx_busy_w, 
		    
		    tx_data_n, 
		    tx_data_e, 
		    tx_data_s, 
		    tx_data_w, 
		    
		    error,
		    led
		    
		    ); 

// 	wire reset, clk;

	output rx_busy_w, rx_busy_s,rx_busy_e, rx_busy_n;
	input  rx_data_w, rx_data_s,rx_data_e, rx_data_n;
	input  tx_busy_w, tx_busy_s,tx_busy_e, tx_busy_n;
	output tx_data_w, tx_data_s,tx_data_e, tx_data_n;
	
	input clk, wclk_n, wclk_e, wclk_s, wclk_w, reset, en;
	output txclk_n, txclk_e, txclk_s, txclk_w, led, error;
	
	input [`ADDR_SZ-1:0] id;
	
	wire [`DIRECTIONS-1:0] rx_busy;
	wire [`DIRECTIONS-2:0] rx_data;
	wire [`DIRECTIONS-1:0] tx_busy;
	wire [`DIRECTIONS-2:0] tx_data;
	
	
	wire  rx_valid_l;
	wire  tx_valid_l;
	
	wire  rx_busy_l;
	wire  tx_busy_l;	
	
	wire [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0]  rx_data_l;
	wire [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0]  tx_data_l;
	
	wire [19:0] flit_counter;
		
// 	clocks 
	wire [`DIRECTIONS-2:0] wclk;
	
	wire [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] source_data ;
	wire source_busy;
	wire source_valid;
	
	
	wire [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] sink_data;
	wire sink_busy;
	wire sink_valid;
	
	// data a busy signals 
	
	assign tx_busy = {tx_busy_l,tx_busy_w, tx_busy_s, tx_busy_e, tx_busy_n};
	
	assign {tx_data_w, tx_data_s,tx_data_e, tx_data_n} = tx_data;
		
	assign rx_data= {rx_data_w, rx_data_s,rx_data_e, rx_data_n};
	
	assign {rx_busy_l,rx_busy_w, rx_busy_s,rx_busy_e, rx_busy_n} = rx_busy;
	
	assign wclk = {wclk_n, wclk_e, wclk_s, wclk_w};
	
	wire txclk;
	
	assign txclk_n = txclk;
	assign txclk_e = txclk;
	assign txclk_s = txclk;
	assign txclk_w = txclk;
	
	
	
	assign rx_data_l  = source_data;
	assign rx_valid_l = source_valid;
	assign source_busy= rx_busy_l;

	assign sink_data  = tx_data_l;
	assign sink_valid = tx_valid_l;
	assign tx_busy_l  = sink_busy;
	
	// router
	
	async_router  router0 (
		      .id(id),
		      .clk(clk),
		      .wclk(wclk), 
		      .clk_fw(txclk),
		      .reset(reset), 
		      .rx_busy(rx_busy), 
		      .rx_data(rx_data), 
		      .rx_l_data(rx_data_l), 
		      .rx_l_valid(rx_valid_l), 
		      .tx_busy(tx_busy), 
		      .tx_data(tx_data), 
		      .tx_l_data(tx_data_l), 
		      .tx_l_valid(tx_valid_l), 
		      .flit_counter(flit_counter)
		      
		      );	

	// Network in interface  
	  
	  NI	NI0 (
		      .id(id),
		      .clk(clk), 
		      .reset(reset), 
		      .item_out(source_data), 
		      .req(source_valid), 
		      .channel_busy(source_busy), 
		      .send_en(en), 
		      .item_in(sink_data), 
		      .valid(sink_valid), 
		      .busy(sink_busy),
		      .error(error),
		      .led(led)
		      
		      );
		      




	
endmodule
