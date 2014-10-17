
`timescale 1ns/100ps

`include "constants.v"
`include "basics.v"
`include "clib/fifo.v"
`include "clib/tx.v"
`include "clib/tx_logic.v"
`include "clib/rx.v"
//`include "clib/source.v"
`include "clib/source_from_memory.v"
`include "clib/router.v"
`include "clib/rx_logic.v"
//`include "clib/sink.v"
`include "clib/moody_sink.v"
`include "clib/routing_table_logic.v"	
	
module testbench(); 

	//wire clk, reset;
	
	generator g1 (.clk(clk), .reset(reset));
	
	// routers:
	// -----------------------------------------------------------------
	
	wire  [`DIRECTIONS-1:0] rx_busy;
	wire  [`DIRECTIONS-1:0] rx_data ;
	wire  [`DIRECTIONS-1:0] tx_busy;
	wire  [`DIRECTIONS-1:0] tx_data;
	wire [19:0] flit_counter ;
	
	wire source_data[`DIRECTIONS-1:0];
	wire source_busy[`DIRECTIONS-1:0];
	
	wire sink_data[`DIRECTIONS-1:0];
	wire sink_busy[`DIRECTIONS-1:0];

	
	
	
	router #(.routerid(`ROUTER_ID)) router0 (.clk(clk), .reset(reset), .rx_busy(rx_busy), .rx_data(rx_data), .tx_busy(tx_busy), .tx_data(tx_data), .table_addr(table_addr), .table_data(table_data), .flit_counter(flit_counter));	
	// routing tables:
	// -----------------------------------------------------------------	
	
	wire [`ADDR_BITS-1:0] table_addr;
	
	wire [`BITS_DIR-1:0] table_data;

	routing_table #(0, "routing_tables/4.txt") rtable0 (reset, table_addr, table_data);

	
	// sources:
	// -----------------------------------------------------------------
	
	serial_source_from_memory #(.id(`ROUTER_ID), .flits(65), .traffic_file("traffic/0.txt")) source4 (.clk(clk), .reset(reset), .serial_out(source_data[`LOCAL]), .busy(source_busy[`LOCAL]));
	serial_source_from_memory #(.id(1), .flits(256), .traffic_file("traffic/0.txt")) source1 (.clk(clk), .reset(reset), .serial_out(source_data[`NORTH]), .busy(source_busy[`NORTH]));
	serial_source_from_memory #(.id(3), .flits(256), .traffic_file("traffic/0.txt")) source3 (.clk(clk), .reset(reset), .serial_out(source_data[`WEST]), .busy(source_busy[`WEST]));
	serial_source_from_memory #(.id(5), .flits(256), .traffic_file("traffic/0.txt")) source5 (.clk(clk), .reset(reset), .serial_out(source_data[`EAST]), .busy(source_busy[`EAST]));
	serial_source_from_memory #(.id(7), .flits(256), .traffic_file("traffic/0.txt")) source7 (.clk(clk), .reset(reset), .serial_out(source_data[`SOUTH]), .busy(source_busy[`SOUTH]));


	// sinks:
	// -----------------------------------------------------------------

	serial_moody_sink #(.id(`ROUTER_ID), .hospitality(255)) sink4 (.clk(clk), .reset(reset), .channel_busy(sink_busy[`LOCAL]), .serial_in(sink_data[`LOCAL]));
	serial_moody_sink #(.id(1), .hospitality(255)) sink1 (.clk(clk), .reset(reset), .channel_busy(sink_busy[`NORTH]), .serial_in(sink_data[`NORTH]));
	serial_moody_sink #(.id(3), .hospitality(255)) sink3 (.clk(clk), .reset(reset), .channel_busy(sink_busy[`WEST]), .serial_in(sink_data[`WEST]));
	serial_moody_sink #(.id(5), .hospitality(255)) sink5 (.clk(clk), .reset(reset), .channel_busy(sink_busy[`EAST]), .serial_in(sink_data[`EAST]));
	serial_moody_sink #(.id(7), .hospitality(255)) sink7 (.clk(clk), .reset(reset), .channel_busy(sink_busy[`SOUTH]), .serial_in(sink_data[`SOUTH]));

	

	assign rx_data[`NORTH] = source_data[`NORTH];
	assign source_busy[`NORTH] = rx_busy[`NORTH];

	assign rx_data[`EAST] = source_data[`EAST];
	assign source_busy[`EAST] = rx_busy[`EAST];
	
	assign rx_data[`SOUTH] = source_data[`SOUTH];
	assign source_busy[`SOUTH] = rx_busy[`SOUTH];

	assign rx_data[`SOUTH] = source_data[`SOUTH];
	assign source_busy[`SOUTH] = rx_busy[`SOUTH];
	
	assign rx_data[`LOCAL] = source_data[`LOCAL];
	assign source_busy[`LOCAL] = rx_busy[`LOCAL];
	
	assign sink_data[`NORTH] = tx_data[`NORTH];
	assign tx_busy[`NORTH] = sink_busy[`NORTH];
	
	assign sink_data[`EAST] = tx_data[`EAST];
	assign tx_busy[`EAST] = sink_busy[`EAST];

	assign sink_data[`SOUTH] = tx_data[`SOUTH];
	assign tx_busy[`SOUTH] = sink_busy[`SOUTH];

	assign sink_data[`WEST] = tx_data[`WEST];
	assign tx_busy[`WEST] = sink_busy[`WEST];
	
	assign sink_data[`LOCAL] = tx_data[`LOCAL];
	assign tx_busy[`LOCAL] = sink_busy[`LOCAL];	
//	assign rx_data[`EAST] = 0;
	
//	assign rx_data[`SOUTH] = 0;
	
	// connections:
	// -----------------------------------------------------------------

	/*
	serial_source_from_memory #(.id(`ROUTER_ID), .flits(256), .traffic_file("traffic/0.txt")) source0 (.clk(clk), .reset(reset), .busy(source_busy), .serial_out(source_data));

	// -----------------------------------------------------------------

	serial_moody_sink #(.id(`ROUTER_ID), .hospitality(255)) sink0 (.clk(clk), .reset(reset), .channel_busy(source_busy), .serial_in(source_data));
	*/

endmodule
