//`timescale 1ns/1ns
	
(* dont_touch = "true" *) module node_wrapper(
            DIP_SW1,	// id,
            SW7, 		// reset, 
            DIP_SW0,	// en,
            LEDS, 		// led,  error,
            
            FMC1_LPC_LA08_P,
            FMC1_LPC_LA08_N,
            FMC1_LPC_LA09_P,
            FMC1_LPC_LA09_N,
                        
                                    
            // north rx
            FMC1_LPC_LA02_P,
            FMC1_LPC_LA02_N,
            FMC1_LPC_LA03_P,
            
            // north tx
            FMC1_LPC_LA12_P,
            FMC1_LPC_LA12_N,
            FMC1_LPC_LA13_P,
	    
	    // south rx
            FMC1_LPC_LA03_N,
            FMC1_LPC_LA04_P,
            FMC1_LPC_LA04_N,
            
            // south tx
            FMC1_LPC_LA13_N,
            FMC1_LPC_LA14_P,
            FMC1_LPC_LA14_N,
            
            // east rx
            FMC1_LPC_LA20_N,
            FMC1_LPC_LA24_N,
            FMC1_LPC_LA21_P,
            
            // east tx
            FMC1_LPC_LA25_P,
            FMC1_LPC_LA21_N,
            FMC1_LPC_LA25_N,
            
            // west rx
            FMC1_LPC_LA22_P,
            FMC1_LPC_LA26_P,
            FMC1_LPC_LA22_N,
            
            // west tx
            FMC1_LPC_LA26_N,
            FMC1_LPC_LA23_P,
            FMC1_LPC_LA27_P,
            
            sys_diff_clock_clk_n,
            sys_diff_clock_clk_p
    ); 

 	`include "constants.v"
// 	`include "fifo.v"
// 	`include "routing_logic_v1.v"
// 	`include "par_rx_logic.v"
// 	`include "routing_table.v"	
// 	`include "rr_arbiter.v"
// 	`include "ch_rx_logic.v"
// 	`include "NI_v1.v"
// 	`include "dclk_rx.v"
// 	`include "dclk_tx.v"
// 	`include "async_router.v"

	input sys_diff_clock_clk_n;
	input sys_diff_clock_clk_p;

// 	wire reset, clk;

//	output rx_busy_w, rx_busy_s,rx_busy_e, rx_busy_n;
//	input  rx_data_w, rx_data_s,rx_data_e, rx_data_n;
//	input  tx_busy_w, tx_busy_s,tx_busy_e, tx_busy_n;
//	output tx_data_w, tx_data_s,tx_data_e, tx_data_n;
	
//	input clk, rxclk_n, rxclk_e, rxclk_s, rxclk_w, reset, en;
//	output txclk_n, txclk_e, txclk_s, txclk_w, led, error;
	
//	input [`ADDR_SZ-1:0] id;

    input   FMC1_LPC_LA08_P;
    input   FMC1_LPC_LA08_N;
    input   FMC1_LPC_LA09_P;
    input   FMC1_LPC_LA09_N;
            
    input DIP_SW0; // en
    input DIP_SW1; // id
    
    
    input SW7; // reset 
    output [7:0] LEDS; // led,  error
    // north rx
    input  FMC1_LPC_LA02_P;
    output FMC1_LPC_LA02_N;
    input  FMC1_LPC_LA03_P;
    
    // north tx
    output FMC1_LPC_LA12_P;
    input  FMC1_LPC_LA12_N;
    output FMC1_LPC_LA13_P;

    // south rx
    input  FMC1_LPC_LA03_N;
    output FMC1_LPC_LA04_P;
    input  FMC1_LPC_LA04_N;
    
    // south tx
    output FMC1_LPC_LA13_N;
    input  FMC1_LPC_LA14_P;
    output FMC1_LPC_LA14_N;
    
    // east rx
    input  FMC1_LPC_LA20_N;
    output FMC1_LPC_LA24_N;
    input  FMC1_LPC_LA21_P;
            
    // east tx
    output FMC1_LPC_LA25_P;
    input  FMC1_LPC_LA21_N;
    output FMC1_LPC_LA25_N;
            
    // west rx
    input  FMC1_LPC_LA22_P;
    output FMC1_LPC_LA26_P;
    input  FMC1_LPC_LA22_N;
            
    // west tx
    output FMC1_LPC_LA26_N;
    input  FMC1_LPC_LA23_P;
    output FMC1_LPC_LA27_P;

                
    // north rx
    assign rxclk_n  = FMC1_LPC_LA02_P;
    assign FMC1_LPC_LA02_N = rx_busy_n;
    assign rx_data_n = FMC1_LPC_LA03_P;
    
    // north tx
    assign FMC1_LPC_LA12_P = txclk_n;
    assign tx_busy_n = FMC1_LPC_LA12_N;
    assign FMC1_LPC_LA13_P = tx_data_n;

    // east rx
    assign rxclk_e = FMC1_LPC_LA20_N;
    assign FMC1_LPC_LA24_N = rx_busy_e;
    assign rx_data_e = FMC1_LPC_LA21_P;
    
    // east tx
    assign FMC1_LPC_LA25_P = txclk_e;
    assign tx_busy_e = FMC1_LPC_LA21_N;
    assign FMC1_LPC_LA25_N = tx_data_e;

    // south rx
    assign rxclk_s = FMC1_LPC_LA03_N;
    assign FMC1_LPC_LA04_P = rx_busy_s;
    assign rx_data_s = FMC1_LPC_LA04_N;
    
    // south tx
    assign FMC1_LPC_LA13_N = txclk_s;
    assign tx_busy_s = FMC1_LPC_LA14_P;
    assign FMC1_LPC_LA14_N = tx_data_s;
    
    // west rx
    assign rxclk_w = FMC1_LPC_LA22_P;
    assign FMC1_LPC_LA26_P = rx_busy_w;
    assign rx_data_w = FMC1_LPC_LA22_N;
    
    // west tx
    assign FMC1_LPC_LA26_N = txclk_w;
    assign tx_busy_w = FMC1_LPC_LA23_P;
    assign FMC1_LPC_LA27_P = tx_data_w;

                        
	wire [`ADDR_SZ-1:0] id;
	    
	assign id = {FMC1_LPC_LA08_P, FMC1_LPC_LA08_N, FMC1_LPC_LA09_P, FMC1_LPC_LA09_N};
	
	
	
	assign reset = !SW7; 
	
	assign en = DIP_SW0;
	
	assign LEDS[0] = error;
	
	assign LEDS[1] = led; 
    
	
	wire [`DIRECTIONS-1:0] rx_busy;
	wire [`DIRECTIONS-2:0] rx_data;
	wire [`DIRECTIONS-2:0] rxclk;
	wire [`DIRECTIONS-1:0] tx_busy;
	wire [`DIRECTIONS-2:0] tx_data;
	
	
	wire  rx_valid_l;
	wire  tx_valid_l;
	
	wire  rx_busy_l;
	wire  tx_busy_l;	
	
	wire [`HDR_SZ + `PL_SZ + `ADDR_SZ - 1 : 0]  rx_data_l;
	wire [`HDR_SZ + `PL_SZ + `ADDR_SZ - 1 : 0]  tx_data_l;
	
	wire [19:0] flit_counter;
		
// 	clocks 
	
	wire [`HDR_SZ + `PL_SZ + `ADDR_SZ - 1:0] source_data ;
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
	
	assign rxclk = {rxclk_n, rxclk_e, rxclk_s, rxclk_w};
	
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
	
	// clock source
	wire CLK05;

	    clk_src clk_src_i
                (
                .CLK05(CLK05),
                .reset_rtl(reset),
                .sys_diff_clock_clk_n(sys_diff_clock_clk_n),
                .sys_diff_clock_clk_p(sys_diff_clock_clk_p)
                );

    assign clk = CLK05;
    
	
	// router
	
	async_router  router0 (
		      .id(id),
		      .clk(clk),
		      .wclk(rxclk), 
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
