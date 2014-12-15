`timescale 1ns/1ns

`include "async_clib/constants.v"
`include "par_clib/fifo2.v"
`include "par_clib/routing_logic_v1.v"
// `include "par_clib/par_rx.v"
// `include "par_clib/par_tx.v"
// `include "par_clib/par_source_traffic.v"
// `include "par_clib/par_source_data.v"
`include "par_clib/par_rx_logic.v"
// `include "par_clib/par_moody_sink.v"
//`include "par_clib/routing_table_logic.v"	
`include "par_clib/routing_table.v"	
`include "par_clib/rr_arbiter.v"
`include "par_clib/ch_rx_logic.v"
`include "par_clib/NI_v2.v"

`include "async_clib/dclk_rx4.v"
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


	
	async_router  
	  router0 (0, clk[0], wclk[0], clk_fw[0], reset, rx_busy[0], rx_data[0], rx_l_data[0], rx_l_valid[0], tx_busy[0], tx_data[0], tx_l_data[0], tx_l_valid[0], flit_counter[0]);	
	
	async_router  
	  router1 (1, clk[1], wclk[1], clk_fw[1], reset, rx_busy[1], rx_data[1], rx_l_data[1], rx_l_valid[1], tx_busy[1], tx_data[1], tx_l_data[1], tx_l_valid[1], flit_counter[1]);	
	  
	  
	  NI  NI0 (     
		    .id(0),
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
	  
	  NI  NI1 (     
		    .id(1),
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
	
	  wire [3:0] id;
	  assign  id = 0;
	  reg [31:0] counterx;
	  reg  toggling;
	  
	  assign clkx = (id==1) ? clk[0] : clk[1] ;
	  
// 	  assign LEDS[7]=toggling;
	  
	   always @(posedge clkx) begin
	
		if (reset)  begin
			toggling <= 0;
			counterx <= 0;
		end
			
		else 
		
	  	    if (counterx > 1000) begin
	  	    	  toggling <= !toggling;
	  	    	  counterx <= 0;
	  	    	  
	  	    end
		    else counterx <= counterx + 1;

	    end	      
	  
	
endmodule


// create_debug_core u_ila_0 ila
// set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
// set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
// set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
// set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
// set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
// set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
// set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
// set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
// set_property port_width 1 [get_debug_ports u_ila_0/clk]
// connect_debug_port u_ila_0/clk [get_nets clk_src_i/CLK100]
// set_property port_width 20 [get_debug_ports u_ila_0/probe0]
// connect_debug_port u_ila_0/probe0 [get_nets [list {router0/flit_counter[0]} {router0/flit_counter[1]} {router0/flit_counter[2]} {router0/flit_counter[3]} {router0/flit_counter[4]} {router0/flit_counter[5]} {router0/flit_counter[6]} {router0/flit_counter[7]} {router0/flit_counter[8]} {router0/flit_counter[9]} {router0/flit_counter[10]} {router0/flit_counter[11]} {router0/flit_counter[12]} {router0/flit_counter[13]} {router0/flit_counter[14]} {router0/flit_counter[15]} {router0/flit_counter[16]} {router0/flit_counter[17]} {router0/flit_counter[18]} {router0/flit_counter[19]}]]
// set_property C_CLK_INPUT_FREQ_HZ 100000000 [get_debug_cores dbg_hub]
// set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
// set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
// connect_debug_port dbg_hub/clk [get_nets clk_src_i/CLK100]