
`timescale 1ns/100ps

`include "constants.v"
`include "basics.v"


`include "clib/fifo.v"
`include "clib/tx.v"
`include "clib/routing_logic.v"
`include "clib/rx.v"
`include "clib/source_traffic.v"
// `include "clib/source_data.v"
`include "clib/rr_router.v"
`include "clib/rr_arbiter.v"
`include "clib/ch_rx_logic.v"
`include "clib/moody_sink.v"
`include "clib/routing_table_logic.v"	

module testbench(); 

wire clk,reset;

	//wire clk, reset;
	parameter PIR=255; // packet injection rate 0-255
	parameter SINK_HOSP=255; // sink hospitality 0-255
	parameter DESTS =16;
	parameter traffic_file="traffic/1.txt";

	generator g1 (clk, reset, send);
	
	// routers:
	// -----------------------------------------------------------------
	
	wire [4:0] rx_busy [`NUM_NODES-1:0];
	wire [4:0] rx_data [`NUM_NODES-1:0];
	wire [4:0] tx_busy [`NUM_NODES-1:0];
	wire [4:0] tx_data [`NUM_NODES-1:0];
	wire [`NUM_NODES-1:0] router_active;
	wire [19:0] flit_counter [`NUM_NODES-1:0];
	
// 	genvar r;
// 	generate
// 		for (r = 0; r < `NUM_NODES; r = r + 1) begin: routers
// 		    router #(r) router (clk, reset, rx_busy[r], rx_data[r], tx_busy[r], tx_data[r], table_addr[r], table_data[r], flit_counter[r]);	
// 		end
// 	endgenerate
	
	rr_router #(0,"routing_tables4x4/0.txt") router0 (clk, reset, rx_busy[0], rx_data[0], tx_busy[0], tx_data[0], flit_counter[0]);	
	rr_router #(1,"routing_tables4x4/1.txt") router1 (clk, reset, rx_busy[1], rx_data[1], tx_busy[1], tx_data[1], flit_counter[1]);
	rr_router #(2,"routing_tables4x4/2.txt") router2 (clk, reset, rx_busy[2], rx_data[2], tx_busy[2], tx_data[2], flit_counter[2]);
	rr_router #(3,"routing_tables4x4/3.txt") router3 (clk, reset, rx_busy[3], rx_data[3], tx_busy[3], tx_data[3], flit_counter[3]);
	rr_router #(4,"routing_tables4x4/4.txt") router4 (clk, reset, rx_busy[4], rx_data[4], tx_busy[4], tx_data[4], flit_counter[4]);
	rr_router #(5,"routing_tables4x4/5.txt") router5 (clk, reset, rx_busy[5], rx_data[5], tx_busy[5], tx_data[5], flit_counter[5]);
	rr_router #(6,"routing_tables4x4/6.txt") router6 (clk, reset, rx_busy[6], rx_data[6], tx_busy[6], tx_data[6], flit_counter[6]);
	rr_router #(7,"routing_tables4x4/7.txt") router7 (clk, reset, rx_busy[7], rx_data[7], tx_busy[7], tx_data[7], flit_counter[7]);
	rr_router #(8,"routing_tables4x4/8.txt") router8 (clk, reset, rx_busy[8], rx_data[8], tx_busy[8], tx_data[8], flit_counter[8]);
	rr_router #(9,"routing_tables4x4/9.txt") router9 (clk, reset, rx_busy[9], rx_data[9], tx_busy[9], tx_data[9], flit_counter[9]);
	rr_router #(10,"routing_tables4x4/10.txt") router10 (clk, reset, rx_busy[10], rx_data[10], tx_busy[10], tx_data[10], flit_counter[10]);
	rr_router #(11,"routing_tables4x4/11.txt") router11 (clk, reset, rx_busy[11], rx_data[11], tx_busy[11], tx_data[11], flit_counter[11]);
	rr_router #(12,"routing_tables4x4/12.txt") router12 (clk, reset, rx_busy[12], rx_data[12], tx_busy[12], tx_data[12], flit_counter[12]);
	rr_router #(13,"routing_tables4x4/13.txt") router13 (clk, reset, rx_busy[13], rx_data[13], tx_busy[13], tx_data[13], flit_counter[13]);
	rr_router #(14,"routing_tables4x4/14.txt") router14 (clk, reset, rx_busy[14], rx_data[14], tx_busy[14], tx_data[14], flit_counter[14]);
	rr_router #(15,"routing_tables4x4/15.txt") router15 (clk, reset, rx_busy[15], rx_data[15], tx_busy[15], tx_data[15], flit_counter[15]);

	// routing tables:
	// -----------------------------------------------------------------	
	
	wire [`ADDR_BITS-1:0] table_addr [`NUM_NODES-1:0];
	
	wire [`BITS_DIR-1:0] table_data [`NUM_NODES-1:0];
	genvar rt;
// 	generate
// 		for (rt = 0; rt < `NUM_NODES; rt = rt + 1) begin: rts
// 		    routing_table #(rt,$psprintf("routing_tables4x4/%d.txt",rt)) rtable (reset, table_addr[rt], table_data[rt]);
// 		end
// 	endgenerate
	
/*	routing_table #(0,"routing_tables4x4/0.txt") rtable0 (table_addr[0], table_data[0]);
	routing_table #(1,"routing_tables4x4/0.txt") rtable1 (table_addr[1], table_data[1]);
	routing_table #(2,"routing_tables4x4/2.txt") rtable2 (table_addr[2], table_data[2]);
	routing_table #(3,"routing_tables4x4/3.txt") rtable3 (table_addr[3], table_data[3]);
	routing_table #(4,"routing_tables4x4/4.txt") rtable4 (table_addr[4], table_data[4]);
	routing_table #(5,"routing_tables4x4/5.txt") rtable5 (table_addr[5], table_data[5]);
	routing_table #(6,"routing_tables4x4/6.txt") rtable6 (table_addr[6], table_data[6]);
	routing_table #(7,"routing_tables4x4/7.txt") rtable7 (table_addr[7], table_data[7]);
	routing_table #(8,"routing_tables4x4/8.txt") rtable8 (table_addr[8], table_data[8]);
	routing_table #(9,"routing_tables4x4/9.txt") rtable9 (table_addr[9], table_data[9]);
	routing_table #(10,"routing_tables4x4/10.txt") rtable10 (table_addr[10], table_data[10]);
	routing_table #(11,"routing_tables4x4/10.txt") rtable11 (table_addr[11], table_data[11]);
	routing_table #(12,"routing_tables4x4/12.txt") rtable12 (table_addr[12], table_data[12]);
	routing_table #(13,"routing_tables4x4/13.txt") rtable13 (table_addr[13], table_data[13]);
	routing_table #(14,"routing_tables4x4/14.txt") rtable14 (table_addr[14], table_data[14]);
	routing_table #(15,"routing_tables4x4/15.txt") rtable15 (table_addr[15], table_data[15]);	*/
	
	// sources:
	// -----------------------------------------------------------------
	
	wire source_data [`NUM_NODES-1:0];
	wire source_busy [`NUM_NODES-1:0];
	
// 	genvar src;
// 	generate
// 		for (src = 0; src < `NUM_NODES; src = src + 1) begin: sources
// 		  serial_source_from_memory #(src, PIR, $sformatf("traffic/%d.txt",src)) source (clk, reset, source_data[src], source_busy[src],send);
// 		end
// 	endgenerate
// 	
	serial_source_from_memory #(0, DESTS, PIR, traffic_file) source0 (clk, reset, source_data[0], source_busy[0], send);
	serial_source_from_memory #(1, DESTS, PIR, traffic_file) source1 (clk, reset, source_data[1], source_busy[1], send);
	serial_source_from_memory #(2, DESTS, PIR, traffic_file) source2 (clk, reset, source_data[2], source_busy[2], send);
	serial_source_from_memory #(3, DESTS, PIR, traffic_file) source3 (clk, reset, source_data[3], source_busy[3], send);
	serial_source_from_memory #(4, DESTS, PIR, traffic_file) source4 (clk, reset, source_data[4], source_busy[4], send);
	serial_source_from_memory #(5, DESTS, PIR, traffic_file) source5 (clk, reset, source_data[5], source_busy[5], send);
	serial_source_from_memory #(6, DESTS, PIR, traffic_file) source6 (clk, reset, source_data[6], source_busy[6], send);
	serial_source_from_memory #(7, DESTS, PIR, traffic_file) source7 (clk, reset, source_data[7], source_busy[7], send);
	serial_source_from_memory #(8, DESTS, PIR, traffic_file) source8 (clk, reset, source_data[8], source_busy[8], send);
	serial_source_from_memory #(9, DESTS, PIR, traffic_file) source9 (clk, reset, source_data[9], source_busy[9], send);
	serial_source_from_memory #(10, DESTS, PIR, traffic_file) source10 (clk, reset, source_data[10], source_busy[10], send);
	serial_source_from_memory #(11, DESTS, PIR, traffic_file) source11 (clk, reset, source_data[11], source_busy[11], send);
	serial_source_from_memory #(12, DESTS, PIR, traffic_file) source12 (clk, reset, source_data[12], source_busy[12], send);
	serial_source_from_memory #(13, DESTS, PIR, traffic_file) source13 (clk, reset, source_data[13], source_busy[13], send);
	serial_source_from_memory #(14, DESTS, PIR, traffic_file) source14 (clk, reset, source_data[14], source_busy[14], send);
	serial_source_from_memory #(15, DESTS, PIR, traffic_file) source15 (clk, reset, source_data[15], source_busy[15], send);

	// sinks:
	// -----------------------------------------------------------------
	
	wire sink_data [`NUM_NODES-1:0];
	wire sink_busy [`NUM_NODES-1:0];
	
// 	genvar snk;
// 	generate
// 		for (snk = 0; snk < `NUM_NODES; snk = snk + 1) begin: sinks
// 		  serial_moody_sink #(snk, 255) sink (clk, reset, sink_busy[snk], sink_data[snk]);
// 		end
// 	endgenerate
	
	serial_moody_sink #(0, SINK_HOSP) sink0 (clk, reset, sink_busy[0], sink_data[0]);
	serial_moody_sink #(1, SINK_HOSP) sink1 (clk, reset, sink_busy[1], sink_data[1]);
	serial_moody_sink #(2, SINK_HOSP) sink2 (clk, reset, sink_busy[2], sink_data[2]);
	serial_moody_sink #(3, SINK_HOSP) sink3 (clk, reset, sink_busy[3], sink_data[3]);
	serial_moody_sink #(4, SINK_HOSP) sink4 (clk, reset, sink_busy[4], sink_data[4]);
	serial_moody_sink #(5, SINK_HOSP) sink5 (clk, reset, sink_busy[5], sink_data[5]);
	serial_moody_sink #(6, SINK_HOSP) sink6 (clk, reset, sink_busy[6], sink_data[6]);
	serial_moody_sink #(7, SINK_HOSP) sink7 (clk, reset, sink_busy[7], sink_data[7]);
	serial_moody_sink #(8, SINK_HOSP) sink8 (clk, reset, sink_busy[8], sink_data[8]);
	serial_moody_sink #(9, SINK_HOSP) sink9 (clk, reset, sink_busy[9], sink_data[9]);
	serial_moody_sink #(10, SINK_HOSP) sink10 (clk, reset, sink_busy[10], sink_data[10]);
	serial_moody_sink #(11, SINK_HOSP) sink11 (clk, reset, sink_busy[11], sink_data[11]);
	serial_moody_sink #(12, SINK_HOSP) sink12 (clk, reset, sink_busy[12], sink_data[12]);
	serial_moody_sink #(13, SINK_HOSP) sink13 (clk, reset, sink_busy[13], sink_data[13]);
	serial_moody_sink #(14, SINK_HOSP) sink14 (clk, reset, sink_busy[14], sink_data[14]);
	serial_moody_sink #(15, SINK_HOSP) sink15 (clk, reset, sink_busy[15], sink_data[15]);	
	

		
	// connections:
	// -----------------------------------------------------------------
	
	`include "create_noc/connections.v"

endmodule
