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
	
module testbench(CLOCK_50, LEDR, KEY); 

input CLOCK_50, KEY;
output [15:0]LEDR;


assign clk=CLOCK_50;
assign reset = !KEY;

assign LEDR=router_active;


	wire clk, reset;
	
	//generator g1 (clk, reset);
	
	// routers:
	// -----------------------------------------------------------------
	
	wire [4:0] rx_busy [`NUM_NODES-1:0];
	wire [4:0] rx_data [`NUM_NODES-1:0];
	wire [4:0] tx_busy [`NUM_NODES-1:0];
	wire [4:0] tx_data [`NUM_NODES-1:0];
	wire [`NUM_NODES-1:0] router_active;
	
	router #(0) router0 (clk, reset, rx_busy[0], rx_data[0], tx_busy[0], tx_data[0], table_addr[0], table_data[0], router_active[0]);	
	router #(1) router1 (clk, reset, rx_busy[1], rx_data[1], tx_busy[1], tx_data[1], table_addr[1], table_data[1], router_active[1]);
	router #(2) router2 (clk, reset, rx_busy[2], rx_data[2], tx_busy[2], tx_data[2], table_addr[2], table_data[2], router_active[2]);
	router #(3) router3 (clk, reset, rx_busy[3], rx_data[3], tx_busy[3], tx_data[3], table_addr[3], table_data[3], router_active[3]);
	router #(4) router4 (clk, reset, rx_busy[4], rx_data[4], tx_busy[4], tx_data[4], table_addr[4], table_data[4], router_active[4]);
	router #(5) router5 (clk, reset, rx_busy[5], rx_data[5], tx_busy[5], tx_data[5], table_addr[5], table_data[5], router_active[5]);
	router #(6) router6 (clk, reset, rx_busy[6], rx_data[6], tx_busy[6], tx_data[6], table_addr[6], table_data[6], router_active[6]);
	router #(7) router7 (clk, reset, rx_busy[7], rx_data[7], tx_busy[7], tx_data[7], table_addr[7], table_data[7], router_active[7]);
	router #(8) router8 (clk, reset, rx_busy[8], rx_data[8], tx_busy[8], tx_data[8], table_addr[8], table_data[8], router_active[8]);
	router #(9) router9 (clk, reset, rx_busy[9], rx_data[9], tx_busy[9], tx_data[9], table_addr[9], table_data[9], router_active[9]);
	router #(10) router10 (clk, reset, rx_busy[10], rx_data[10], tx_busy[10], tx_data[10], table_addr[10], table_data[10], router_active[10]);
	router #(11) router11 (clk, reset, rx_busy[11], rx_data[11], tx_busy[11], tx_data[11], table_addr[11], table_data[11], router_active[11]);
	router #(12) router12 (clk, reset, rx_busy[12], rx_data[12], tx_busy[12], tx_data[12], table_addr[12], table_data[12], router_active[12]);
	router #(13) router13 (clk, reset, rx_busy[13], rx_data[13], tx_busy[13], tx_data[13], table_addr[13], table_data[13], router_active[13]);
	router #(14) router14 (clk, reset, rx_busy[14], rx_data[14], tx_busy[14], tx_data[14], table_addr[14], table_data[14], router_active[14]);
	router #(15) router15 (clk, reset, rx_busy[15], rx_data[15], tx_busy[15], tx_data[15], table_addr[15], table_data[15], router_active[15]);

	// routing tables:
	// -----------------------------------------------------------------	
	
	wire [`SIZE-1:0] table_addr [`NUM_NODES-1:0];
	
	wire [`BITS_DIR-1:0] table_data [`NUM_NODES-1:0];

	routing_table #(0) rtable0 (reset, table_addr[0], table_data[0]);
	routing_table #(1) rtable1 (reset, table_addr[1], table_data[1]);
	routing_table #(2) rtable2 (reset, table_addr[2], table_data[2]);
	routing_table #(3) rtable3 (reset, table_addr[3], table_data[3]);
	routing_table #(4) rtable4 (reset, table_addr[4], table_data[4]);
	routing_table #(5) rtable5 (reset, table_addr[5], table_data[5]);
	routing_table #(6) rtable6 (reset, table_addr[6], table_data[6]);
	routing_table #(7) rtable7 (reset, table_addr[7], table_data[7]);
	routing_table #(8) rtable8 (reset, table_addr[8], table_data[8]);
	routing_table #(9) rtable9 (reset, table_addr[9], table_data[9]);
	routing_table #(10) rtable10 (reset, table_addr[10], table_data[10]);
	routing_table #(11) rtable11 (reset, table_addr[11], table_data[11]);
	routing_table #(12) rtable12 (reset, table_addr[12], table_data[12]);
	routing_table #(13) rtable13 (reset, table_addr[13], table_data[13]);
	routing_table #(14) rtable14 (reset, table_addr[14], table_data[14]);
	routing_table #(15) rtable15 (reset, table_addr[15], table_data[15]);	
	
	// sources:
	// -----------------------------------------------------------------
	
	wire source_data [`NUM_NODES-1:0];
	wire source_busy [`NUM_NODES-1:0];
	
	//serial_source_from_memory #(0, 16, "traffic/0) source0 (clk, reset, source_data[0], source_busy[0]);
	serial_source  source0 (clk, reset, source_data[0], source_busy[0]);
	/*
	serial_source_from_memory #(1, 16, "traffic/0) source1 (clk, reset, source_data[1], source_busy[1]);
	serial_source_from_memory #(2, 16, "traffic/0) source2 (clk, reset, source_data[2], source_busy[2]);
	serial_source_from_memory #(3, 16, "traffic/0) source3 (clk, reset, source_data[3], source_busy[3]);
	serial_source_from_memory #(4, 16, "traffic/0) source4 (clk, reset, source_data[4], source_busy[4]);
	serial_source_from_memory #(5, 16, "traffic/0) source5 (clk, reset, source_data[5], source_busy[5]);
	serial_source_from_memory #(6, 16, "traffic/0) source6 (clk, reset, source_data[6], source_busy[6]);
	serial_source_from_memory #(7, 16, "traffic/0) source7 (clk, reset, source_data[7], source_busy[7]);
	serial_source_from_memory #(8, 16, "traffic/0) source8 (clk, reset, source_data[8], source_busy[8]);
	serial_source_from_memory #(9, 16, "traffic/0) source9 (clk, reset, source_data[9], source_busy[9]);
	serial_source_from_memory #(10, 16, "traffic/0) source10 (clk, reset, source_data[10], source_busy[10]);
	serial_source_from_memory #(11, 16, "traffic/0) source11 (clk, reset, source_data[11], source_busy[11]);
	serial_source_from_memory #(12, 16, "traffic/0) source12 (clk, reset, source_data[12], source_busy[12]);
	serial_source_from_memory #(13, 16, "traffic/0) source13 (clk, reset, source_data[13], source_busy[13]);
	serial_source_from_memory #(14, 16, "traffic/0) source14 (clk, reset, source_data[14], source_busy[14]);
	serial_source_from_memory #(15, 16, "traffic/0) source15 (clk, reset, source_data[15], source_busy[15]);
*/
	// sinks:
	// -----------------------------------------------------------------
	
	wire sink_data [`NUM_NODES-1:0];
	wire sink_busy [`NUM_NODES-1:0];
/*
	serial_moody_sink #(0, 255) sink0 (clk, reset, sink_busy[0], sink_data[0]);
	serial_moody_sink #(1, 255) sink1 (clk, reset, sink_busy[1], sink_data[1]);
	serial_moody_sink #(2, 255) sink2 (clk, reset, sink_busy[2], sink_data[2]);
	serial_moody_sink #(3, 255) sink3 (clk, reset, sink_busy[3], sink_data[3]);
	serial_moody_sink #(4, 255) sink4 (clk, reset, sink_busy[4], sink_data[4]);
	serial_moody_sink #(5, 255) sink5 (clk, reset, sink_busy[5], sink_data[5]);
	serial_moody_sink #(6, 255) sink6 (clk, reset, sink_busy[6], sink_data[6]);
	serial_moody_sink #(7, 255) sink7 (clk, reset, sink_busy[7], sink_data[7]);
	serial_moody_sink #(8, 255) sink8 (clk, reset, sink_busy[8], sink_data[8]);
	serial_moody_sink #(9, 255) sink9 (clk, reset, sink_busy[9], sink_data[9]);
	serial_moody_sink #(10, 255) sink10 (clk, reset, sink_busy[10], sink_data[10]);
	serial_moody_sink #(11, 255) sink11 (clk, reset, sink_busy[11], sink_data[11]);
	serial_moody_sink #(12, 255) sink12 (clk, reset, sink_busy[12], sink_data[12]);
	serial_moody_sink #(13, 255) sink13 (clk, reset, sink_busy[13], sink_data[13]);
	serial_moody_sink #(14, 255) sink14 (clk, reset, sink_busy[14], sink_data[14]);
	serial_moody_sink #(15, 255) sink15 (clk, reset, sink_busy[15], sink_data[15]);	
*/	
	serial_sink sink15 (clk, reset, sink_busy[15], sink_data[15]);	
		
	// connections:
	// -----------------------------------------------------------------
	
//	`include "connections.v"
	assign rx_data[1][3] = tx_data[0][2];
assign tx_busy[0][2] = rx_busy[1][3];

assign rx_data[0][2] = tx_data[1][3];
assign tx_busy[1][3] = rx_busy[0][2];

assign rx_data[2][3] = tx_data[1][2];
assign tx_busy[1][2] = rx_busy[2][3];

assign rx_data[1][2] = tx_data[2][3];
assign tx_busy[2][3] = rx_busy[1][2];

assign rx_data[3][3] = tx_data[2][2];
assign tx_busy[2][2] = rx_busy[3][3];

assign rx_data[2][2] = tx_data[3][3];
assign tx_busy[3][3] = rx_busy[2][2];

assign rx_data[5][3] = tx_data[4][2];
assign tx_busy[4][2] = rx_busy[5][3];

assign rx_data[4][2] = tx_data[5][3];
assign tx_busy[5][3] = rx_busy[4][2];

assign rx_data[6][3] = tx_data[5][2];
assign tx_busy[5][2] = rx_busy[6][3];

assign rx_data[5][2] = tx_data[6][3];
assign tx_busy[6][3] = rx_busy[5][2];

assign rx_data[7][3] = tx_data[6][2];
assign tx_busy[6][2] = rx_busy[7][3];

assign rx_data[6][2] = tx_data[7][3];
assign tx_busy[7][3] = rx_busy[6][2];

assign rx_data[9][3] = tx_data[8][2];
assign tx_busy[8][2] = rx_busy[9][3];

assign rx_data[8][2] = tx_data[9][3];
assign tx_busy[9][3] = rx_busy[8][2];

assign rx_data[10][3] = tx_data[9][2];
assign tx_busy[9][2] = rx_busy[10][3];

assign rx_data[9][2] = tx_data[10][3];
assign tx_busy[10][3] = rx_busy[9][2];

assign rx_data[11][3] = tx_data[10][2];
assign tx_busy[10][2] = rx_busy[11][3];

assign rx_data[10][2] = tx_data[11][3];
assign tx_busy[11][3] = rx_busy[10][2];

assign rx_data[13][3] = tx_data[12][2];
assign tx_busy[12][2] = rx_busy[13][3];

assign rx_data[12][2] = tx_data[13][3];
assign tx_busy[13][3] = rx_busy[12][2];

assign rx_data[14][3] = tx_data[13][2];
assign tx_busy[13][2] = rx_busy[14][3];

assign rx_data[13][2] = tx_data[14][3];
assign tx_busy[14][3] = rx_busy[13][2];

assign rx_data[15][3] = tx_data[14][2];
assign tx_busy[14][2] = rx_busy[15][3];

assign rx_data[14][2] = tx_data[15][3];
assign tx_busy[15][3] = rx_busy[14][2];

assign rx_data[4][0] = tx_data[0][1];
assign tx_busy[0][1] = rx_busy[4][0];

assign rx_data[0][1] = tx_data[4][0];
assign tx_busy[4][0] = rx_busy[0][1];

assign rx_data[5][0] = tx_data[1][1];
assign tx_busy[1][1] = rx_busy[5][0];

assign rx_data[1][1] = tx_data[5][0];
assign tx_busy[5][0] = rx_busy[1][1];

assign rx_data[6][0] = tx_data[2][1];
assign tx_busy[2][1] = rx_busy[6][0];

assign rx_data[2][1] = tx_data[6][0];
assign tx_busy[6][0] = rx_busy[2][1];

assign rx_data[7][0] = tx_data[3][1];
assign tx_busy[3][1] = rx_busy[7][0];

assign rx_data[3][1] = tx_data[7][0];
assign tx_busy[7][0] = rx_busy[3][1];

assign rx_data[8][0] = tx_data[4][1];
assign tx_busy[4][1] = rx_busy[8][0];

assign rx_data[4][1] = tx_data[8][0];
assign tx_busy[8][0] = rx_busy[4][1];

assign rx_data[9][0] = tx_data[5][1];
assign tx_busy[5][1] = rx_busy[9][0];

assign rx_data[5][1] = tx_data[9][0];
assign tx_busy[9][0] = rx_busy[5][1];

assign rx_data[10][0] = tx_data[6][1];
assign tx_busy[6][1] = rx_busy[10][0];

assign rx_data[6][1] = tx_data[10][0];
assign tx_busy[10][0] = rx_busy[6][1];

assign rx_data[11][0] = tx_data[7][1];
assign tx_busy[7][1] = rx_busy[11][0];

assign rx_data[7][1] = tx_data[11][0];
assign tx_busy[11][0] = rx_busy[7][1];

assign rx_data[12][0] = tx_data[8][1];
assign tx_busy[8][1] = rx_busy[12][0];

assign rx_data[8][1] = tx_data[12][0];
assign tx_busy[12][0] = rx_busy[8][1];

assign rx_data[13][0] = tx_data[9][1];
assign tx_busy[9][1] = rx_busy[13][0];

assign rx_data[9][1] = tx_data[13][0];
assign tx_busy[13][0] = rx_busy[9][1];

assign rx_data[14][0] = tx_data[10][1];
assign tx_busy[10][1] = rx_busy[14][0];

assign rx_data[10][1] = tx_data[14][0];
assign tx_busy[14][0] = rx_busy[10][1];

assign rx_data[15][0] = tx_data[11][1];
assign tx_busy[11][1] = rx_busy[15][0];

assign rx_data[11][1] = tx_data[15][0];
assign tx_busy[15][0] = rx_busy[11][1];

assign tx_busy[0][0] = 0;
assign rx_data[0][0] = 0;
assign tx_busy[12][1] = 0;
assign rx_data[12][1] = 0;
assign tx_busy[1][0] = 0;
assign rx_data[1][0] = 0;
assign tx_busy[13][1] = 0;
assign rx_data[13][1] = 0;
assign tx_busy[2][0] = 0;
assign rx_data[2][0] = 0;
assign tx_busy[14][1] = 0;
assign rx_data[14][1] = 0;
assign tx_busy[3][0] = 0;
assign rx_data[3][0] = 0;
assign tx_busy[15][1] = 0;
assign rx_data[15][1] = 0;
assign tx_busy[0][3] = 0;
assign rx_data[0][3] = 0;
assign tx_busy[3][2] = 0;
assign rx_data[3][2] = 0;
assign tx_busy[4][3] = 0;
assign rx_data[4][3] = 0;
assign tx_busy[7][2] = 0;
assign rx_data[7][2] = 0;
assign tx_busy[8][3] = 0;
assign rx_data[8][3] = 0;
assign tx_busy[11][2] = 0;
assign rx_data[11][2] = 0;
assign tx_busy[12][3] = 0;
assign rx_data[12][3] = 0;
assign tx_busy[15][2] = 0;
assign rx_data[15][2] = 0;
assign rx_data[0][4] = source_data[0];
assign source_busy[0] = rx_busy[0][4];

assign sink_data[0] = tx_data[0][4];
assign tx_busy[0][4] = sink_busy[0];

assign rx_data[1][4] = source_data[1];
assign source_busy[1] = rx_busy[1][4];

assign sink_data[1] = tx_data[1][4];
assign tx_busy[1][4] = sink_busy[1];

assign rx_data[2][4] = source_data[2];
assign source_busy[2] = rx_busy[2][4];

assign sink_data[2] = tx_data[2][4];
assign tx_busy[2][4] = sink_busy[2];

assign rx_data[3][4] = source_data[3];
assign source_busy[3] = rx_busy[3][4];

assign sink_data[3] = tx_data[3][4];
assign tx_busy[3][4] = sink_busy[3];

assign rx_data[4][4] = source_data[4];
assign source_busy[4] = rx_busy[4][4];

assign sink_data[4] = tx_data[4][4];
assign tx_busy[4][4] = sink_busy[4];

assign rx_data[5][4] = source_data[5];
assign source_busy[5] = rx_busy[5][4];

assign sink_data[5] = tx_data[5][4];
assign tx_busy[5][4] = sink_busy[5];

assign rx_data[6][4] = source_data[6];
assign source_busy[6] = rx_busy[6][4];

assign sink_data[6] = tx_data[6][4];
assign tx_busy[6][4] = sink_busy[6];

assign rx_data[7][4] = source_data[7];
assign source_busy[7] = rx_busy[7][4];

assign sink_data[7] = tx_data[7][4];
assign tx_busy[7][4] = sink_busy[7];

assign rx_data[8][4] = source_data[8];
assign source_busy[8] = rx_busy[8][4];

assign sink_data[8] = tx_data[8][4];
assign tx_busy[8][4] = sink_busy[8];

assign rx_data[9][4] = source_data[9];
assign source_busy[9] = rx_busy[9][4];

assign sink_data[9] = tx_data[9][4];
assign tx_busy[9][4] = sink_busy[9];

assign rx_data[10][4] = source_data[10];
assign source_busy[10] = rx_busy[10][4];

assign sink_data[10] = tx_data[10][4];
assign tx_busy[10][4] = sink_busy[10];

assign rx_data[11][4] = source_data[11];
assign source_busy[11] = rx_busy[11][4];

assign sink_data[11] = tx_data[11][4];
assign tx_busy[11][4] = sink_busy[11];

assign rx_data[12][4] = source_data[12];
assign source_busy[12] = rx_busy[12][4];

assign sink_data[12] = tx_data[12][4];
assign tx_busy[12][4] = sink_busy[12];

assign rx_data[13][4] = source_data[13];
assign source_busy[13] = rx_busy[13][4];

assign sink_data[13] = tx_data[13][4];
assign tx_busy[13][4] = sink_busy[13];

assign rx_data[14][4] = source_data[14];
assign source_busy[14] = rx_busy[14][4];

assign sink_data[14] = tx_data[14][4];
assign tx_busy[14][4] = sink_busy[14];

assign rx_data[15][4] = source_data[15];
assign source_busy[15] = rx_busy[15][4];

assign sink_data[15] = tx_data[15][4];
assign tx_busy[15][4] = sink_busy[15];


endmodule
