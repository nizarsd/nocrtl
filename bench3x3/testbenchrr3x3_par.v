`timescale 1ns/100ps

`include "constants.v"
`include "basics.v"

`include "../par_clib/fifo.v"
`include "../par_clib/tx.v"
`include "../par_clib/routing_logic.v"
`include "../par_clib/rx.v"
`include "../par_clib/par_rx.v"
`include "../par_clib/par_tx.v"
`include "../par_clib/par_source_traffic.v"
// `include "../par_clib/par_source_data.v"
`include "../par_clib/par_router_rr.v"
`include "../par_clib/par_rx_logic.v"
`include "../par_clib/par_moody_sink.v"
`include "../par_clib/routing_table_logic.v"	
`include "../par_clib/rr_arbiter.v"
`include "../par_clib/ch_rx_logic.v"


	
module testbench(); 

wire clk,reset;

	//wire clk, reset;
	parameter PIR=255; // packet injection rate 0-255
	parameter SINK_HOSP=255; // sink hospitality 0-255
	parameter DESTS =9;
	parameter traffic_file="../traffic/1.txt";

	generator g1 (clk, reset, send);
	
	// routers:
	// -----------------------------------------------------------------
	
	wire [4:0] rx_busy [`NUM_NODES-1:0];
	wire [3:0] rx_data [`NUM_NODES-1:0];
	wire [4:0] tx_busy [`NUM_NODES-1:0];
	wire [3:0] tx_data [`NUM_NODES-1:0];
	
	wire  rx_l_valid [`NUM_NODES-1:0];
	wire  tx_l_valid [`NUM_NODES-1:0];
	wire [`PAYLOAD_SIZE+`ADDR_BITS-1:0]  rx_l_data [`NUM_NODES-1:0];
	wire [`PAYLOAD_SIZE+`ADDR_BITS-1:0]  tx_l_data [`NUM_NODES-1:0];
	
	
	wire  router_active [`NUM_NODES-1:0];
	wire [19:0] flit_counter [`NUM_NODES-1:0];
	
// 	genvar r;
// 	generate
// 		for (r = 0; r < `NUM_NODES; r = r + 1) begin: routers
// 		    router #(r) router (clk, reset, rx_busy[r], rx_data[r], tx_busy[r], tx_data[r], table_addr[r], table_data[r], flit_counter[r]);	
// 		end
// 	endgenerate
	
	par_router  #(0,"../routing_tables/0.txt") router0 (clk, reset, rx_busy[0], rx_data[0], rx_l_data[0], rx_l_valid[0], tx_busy[0], tx_data[0], tx_l_data[0], tx_l_valid[0], flit_counter[0]);	
	par_router  #(1,"../routing_tables/1.txt") router1 (clk, reset, rx_busy[1], rx_data[1], rx_l_data[1], rx_l_valid[1], tx_busy[1], tx_data[1], tx_l_data[1], tx_l_valid[1], flit_counter[1]);	
	par_router  #(2,"../routing_tables/2.txt") router2 (clk, reset, rx_busy[2], rx_data[2], rx_l_data[2], rx_l_valid[2], tx_busy[2], tx_data[2], tx_l_data[2], tx_l_valid[2], flit_counter[2]);	
	par_router  #(3,"../routing_tables/3.txt") router3 (clk, reset, rx_busy[3], rx_data[3], rx_l_data[3], rx_l_valid[3], tx_busy[3], tx_data[3], tx_l_data[3], tx_l_valid[3], flit_counter[3]);	
	par_router  #(4,"../routing_tables/4.txt") router4 (clk, reset, rx_busy[4], rx_data[4], rx_l_data[4], rx_l_valid[4], tx_busy[4], tx_data[4], tx_l_data[4], tx_l_valid[4], flit_counter[4]);	
	par_router  #(5,"../routing_tables/5.txt") router5 (clk, reset, rx_busy[5], rx_data[5], rx_l_data[5], rx_l_valid[5], tx_busy[5], tx_data[5], tx_l_data[5], tx_l_valid[5], flit_counter[5]);	
	par_router  #(6,"../routing_tables/6.txt") router6 (clk, reset, rx_busy[6], rx_data[6], rx_l_data[6], rx_l_valid[6], tx_busy[6], tx_data[6], tx_l_data[6], tx_l_valid[6], flit_counter[6]);	
	par_router  #(7,"../routing_tables/7.txt") router7 (clk, reset, rx_busy[7], rx_data[7], rx_l_data[7], rx_l_valid[7], tx_busy[7], tx_data[7], tx_l_data[7], tx_l_valid[7], flit_counter[7]);	
	par_router  #(8,"../routing_tables/8.txt") router8 (clk, reset, rx_busy[8], rx_data[8], rx_l_data[8], rx_l_valid[8], tx_busy[8], tx_data[8], tx_l_data[8], tx_l_valid[8], flit_counter[8]);	
	
	

	// routing tables:
	// -----------------------------------------------------------------	
	
	wire [`ADDR_BITS-1:0] table_addr [`NUM_NODES-1:0];
	
	wire [`BITS_DIR-1:0] table_data [`NUM_NODES-1:0];
	
// 	genvar rt;
// 	generate
// 		for (rt = 0; rt < `NUM_NODES; rt = rt + 1) begin: rts
// 		    routing_table #(rt,$psprintf("../routing_tables/%d.txt",rt)) rtable (reset, table_addr[rt], table_data[rt]);
// 		end
// 	endgenerate
	
	
	// sources:
	// -----------------------------------------------------------------
	
	wire [`PAYLOAD_SIZE+`ADDR_BITS-1:0] source_data [`NUM_NODES-1:0];
	
	wire source_busy [`NUM_NODES-1:0];
	
	wire source_valid [`NUM_NODES-1:0];
	
// 	genvar src;
// 	generate
// 		for (src = 0; src < `NUM_NODES; src = src + 1) begin: sources
// 		  serial_source_from_memory #(src, PIR, $sformatf("traffic/%d.txt",src)) source (clk, reset, source_data[src], source_busy[src],send);
// 		end
// 	endgenerate
// 	
	par_source_from_memory #(0, DESTS, PIR, traffic_file) source0 (clk, reset, source_data[0], source_valid[0], source_busy[0], send);
	par_source_from_memory #(1, DESTS, PIR, traffic_file) source1 (clk, reset, source_data[1], source_valid[1], source_busy[1], send);
	par_source_from_memory #(2, DESTS, PIR, traffic_file) source2 (clk, reset, source_data[2], source_valid[2], source_busy[2], send);
	par_source_from_memory #(3, DESTS, PIR, traffic_file) source3 (clk, reset, source_data[3], source_valid[3], source_busy[3], send);
	par_source_from_memory #(4, DESTS, PIR, traffic_file) source4 (clk, reset, source_data[4], source_valid[4], source_busy[4], send);
	par_source_from_memory #(5, DESTS, PIR, traffic_file) source5 (clk, reset, source_data[5], source_valid[5], source_busy[5], send);
	par_source_from_memory #(6, DESTS, PIR, traffic_file) source6 (clk, reset, source_data[6], source_valid[6], source_busy[6], send);
	par_source_from_memory #(7, DESTS, PIR, traffic_file) source7 (clk, reset, source_data[7], source_valid[7], source_busy[7], send);
	par_source_from_memory #(8, DESTS, PIR, traffic_file) source8 (clk, reset, source_data[8], source_valid[8], source_busy[8], send);

	// sinks:
	// -----------------------------------------------------------------
	
	wire [`PAYLOAD_SIZE+`ADDR_BITS-1:0] sink_data [`NUM_NODES-1:0];
	
	wire sink_busy [`NUM_NODES-1:0];
		
	wire sink_valid [`NUM_NODES-1:0];
	
	
// 	genvar snk;
// 	generate
// 		for (snk = 0; snk < `NUM_NODES; snk = snk + 1) begin: sinks
// 		  serial_moody_sink #(snk, 255) sink (clk, reset, sink_busy[snk], sink_data[snk]);
// 		end
// 	endgenerate
	
	par_moody_sink #(0, SINK_HOSP) sink0 (clk, reset, sink_busy[0], sink_data[0], sink_valid[0]);
	par_moody_sink #(1, SINK_HOSP) sink1 (clk, reset, sink_busy[1], sink_data[1], sink_valid[1]);
	par_moody_sink #(2, SINK_HOSP) sink2 (clk, reset, sink_busy[2], sink_data[2], sink_valid[2]);
	par_moody_sink #(3, SINK_HOSP) sink3 (clk, reset, sink_busy[3], sink_data[3], sink_valid[3]);
	par_moody_sink #(4, SINK_HOSP) sink4 (clk, reset, sink_busy[4], sink_data[4], sink_valid[4]);
	par_moody_sink #(5, SINK_HOSP) sink5 (clk, reset, sink_busy[5], sink_data[5], sink_valid[5]);
	par_moody_sink #(6, SINK_HOSP) sink6 (clk, reset, sink_busy[6], sink_data[6], sink_valid[6]);
	par_moody_sink #(7, SINK_HOSP) sink7 (clk, reset, sink_busy[7], sink_data[7], sink_valid[7]);
	par_moody_sink #(8, SINK_HOSP) sink8 (clk, reset, sink_busy[8], sink_data[8], sink_valid[8]);
	
	
		
	// connections:
	// -----------------------------------------------------------------
	
	`include "../par_clib/create_noc/connections.v"

endmodule
