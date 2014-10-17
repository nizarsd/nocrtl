
`timescale 1ns/100ps

`include "constants.v"
`include "fifo.v"
`include "basics.v"
`include "tx.v"
`include "tx_logic.v"
`include "rx.v"
//`include "source.v"
`include "source_from_memory.v"
`include "router.v"
`include "rx_logic.v"
//`include "sink.v"
`include "moody_sink.v"
`include "routing_table_logic.v"	
	
module testbench(); 

	wire clk, reset;
	
	generator g1 (.clk(clk), .reset(reset));
	
	// routers:
	// -----------------------------------------------------------------
	
	wire  [`DIRECTIONS-1:0] rx_busy;
	wire  [`DIRECTIONS-1:0] rx_data ;
	wire  [`DIRECTIONS-1:0] tx_busy;
	wire  [`DIRECTIONS-1:0] tx_data;
	wire [19:0] flit_counter ;
	
	wire source_data;
	wire source_busy;
	
	wire sink_data[`DIRECTIONS-1:0];
	wire sink_busy[`DIRECTIONS-1:0];

	
	
	
	router #(.routerid(`ROUTER_ID)) router0 (.clk(clk), .reset(reset), .rx_busy(rx_busy), .rx_data(rx_data), .tx_busy(tx_busy), .tx_data(tx_data), .table_addr(table_addr), .table_data(table_data), .flit_counter(flit_counter));	
	// routing tables:
	// -----------------------------------------------------------------	
	
	wire [`SIZE-1:0] table_addr;
	
	wire [`BITS_DIR-1:0] table_data;

	routing_table #(0, "routing_tables/0.txt") rtable0 (reset, table_addr, table_data);

	
	// sources:
	// -----------------------------------------------------------------
	
	serial_source_from_memory #(.id(`ROUTER_ID), .flits(256), .traffic_file("traffic/0.txt")) source0 (.clk(clk), .reset(reset), .serial_out(source_data), .busy(source_busy));

	// sinks:
	// -----------------------------------------------------------------

	serial_moody_sink #(.id(`ROUTER_ID), .hospitality(255)) sink0 (.clk(clk), .reset(reset), .channel_busy(sink_busy[`DIR_LOCAL]), .serial_in(sink_data[`DIR_LOCAL]));
	serial_moody_sink #(.id(1), .hospitality(255)) sink1 (.clk(clk), .reset(reset), .channel_busy(sink_busy[`DIR_WEST]), .serial_in(sink_data[`DIR_WEST]));
	serial_moody_sink #(.id(3), .hospitality(255)) sink3 (.clk(clk), .reset(reset), .channel_busy(sink_busy[`DIR_NORTH]), .serial_in(sink_data[`DIR_NORTH]));

	assign rx_data[`DIR_LOCAL] = source_data;
	assign source_busy = rx_busy[`DIR_LOCAL];

	assign sink_data[`DIR_LOCAL] = tx_data[`DIR_LOCAL];
	assign tx_busy[`DIR_LOCAL] = sink_busy[`DIR_LOCAL];
	

	assign sink_data[`DIR_WEST] = tx_data[`DIR_EAST];
	assign tx_busy[`DIR_EAST] = sink_busy[`DIR_WEST];
	
	assign sink_data[`DIR_NORTH] = tx_data[`DIR_SOUTH];
	assign tx_busy[`DIR_SOUTH] = sink_busy[`DIR_NORTH];
	
	assign tx_busy[`DIR_WEST]  = 0;
	assign rx_data[`DIR_WEST]  = 0;
	

	assign tx_busy[`DIR_NORTH] = 0;
	assign rx_data[`DIR_NORTH] = 0;
	
//	assign rx_data[`DIR_EAST] = 0;
	
//	assign rx_data[`DIR_SOUTH] = 0;
	
	// connections:
	// -----------------------------------------------------------------

	/*
	serial_source_from_memory #(.id(`ROUTER_ID), .flits(256), .traffic_file("traffic/0.txt")) source0 (.clk(clk), .reset(reset), .busy(source_busy), .serial_out(source_data));

	// -----------------------------------------------------------------

	serial_moody_sink #(.id(`ROUTER_ID), .hospitality(255)) sink0 (.clk(clk), .reset(reset), .channel_busy(source_busy), .serial_in(source_data));
	*/

endmodule
