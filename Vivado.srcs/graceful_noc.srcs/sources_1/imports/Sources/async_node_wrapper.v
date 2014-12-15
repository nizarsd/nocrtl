//`timescale 1ns/1ns
	
(* dont_touch = "true" *) module node_wrapper(
            DIP_SW1,	// id,
            SW7, 		// reset, 
 
	    FMC1_LPC_LA23_N,
	    FMC1_LPC_LA27_N, 

            DIP_SW0,	// en,
            LEDS, 	// led,  error,
                                    
	// North 
	    // rx
            FMC1_LPC_LA00_CC_P,
            FMC1_LPC_LA00_CC_N,
            FMC1_LPC_LA01_CC_P,
            
            // tx
            FMC1_LPC_LA01_CC_N,
            FMC1_LPC_LA02_P,
            FMC1_LPC_LA02_N,
            
	// East   
	    // rx
            FMC1_LPC_LA03_P,
            FMC1_LPC_LA03_N,
            FMC1_LPC_LA04_P,
	    
	    // tx
            FMC1_LPC_LA04_N,
            FMC1_LPC_LA05_P,
            FMC1_LPC_LA05_N,
            
       // South 
	    // rx
            FMC1_LPC_LA06_P,
            FMC1_LPC_LA06_N,
            FMC1_LPC_LA07_P,
            
            // tx
            FMC1_LPC_LA07_N,
            FMC1_LPC_LA08_P,
            FMC1_LPC_LA08_N,
            
      // West 
	    // rx
            FMC1_LPC_LA20_P,
            FMC1_LPC_LA20_N,
            FMC1_LPC_LA21_P,
            
            //tx
            FMC1_LPC_LA21_N,
            FMC1_LPC_LA22_P,
            FMC1_LPC_LA22_N,
            
            // rx_clock forwarded (debug)
            FMC1_LPC_LA24_P, 
            FMC1_LPC_LA24_N, 
            FMC1_LPC_LA25_P, 
            FMC1_LPC_LA25_N,
            
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
	
//	input clk, rx_clk_n, rx_clk_e, rx_clk_s, rx_clk_w, reset, en;
//	output tx_clk_n, tx_clk_e, tx_clk_s, tx_clk_w, led, error;
	
//	input [`ADDR_SZ-1:0] id;

	input DIP_SW0; // en
	input DIP_SW1; // id
	
	
	input SW7; // reset 
 	output FMC1_LPC_LA23_N;  // reset forward for node 0
	input  FMC1_LPC_LA27_N;  // reset for nodes other than 0

	
	output [7:0] LEDS; // led,  error

    // North 
	// rx
	input  FMC1_LPC_LA00_CC_P;
	input  FMC1_LPC_LA00_CC_N;
	output FMC1_LPC_LA01_CC_P;

	// tx
	input  FMC1_LPC_LA01_CC_N;
	output FMC1_LPC_LA02_P;
	output FMC1_LPC_LA02_N;

    // East   
	// rx
	input   FMC1_LPC_LA03_P;
	input   FMC1_LPC_LA03_N;
	output  FMC1_LPC_LA04_P;

	// tx
	input   FMC1_LPC_LA04_N;
	output  FMC1_LPC_LA05_P;
	output  FMC1_LPC_LA05_N;

    // South 
	// rx
	input   FMC1_LPC_LA06_P;
	input   FMC1_LPC_LA06_N;
	output  FMC1_LPC_LA07_P;

	// tx
	input   FMC1_LPC_LA07_N;
	output  FMC1_LPC_LA08_P;
	output  FMC1_LPC_LA08_N;

    // West 
	// rx
	input    FMC1_LPC_LA20_P;
	input    FMC1_LPC_LA20_N;
	output   FMC1_LPC_LA21_P;

	//tx
	input   FMC1_LPC_LA21_N;
	output  FMC1_LPC_LA22_P;
	output  FMC1_LPC_LA22_N;
          
        output FMC1_LPC_LA24_P, FMC1_LPC_LA24_N, FMC1_LPC_LA25_P, FMC1_LPC_LA25_N;
		    
    // North 
	// rx
	assign  rx_clk_n  = FMC1_LPC_LA00_CC_P;
	assign  rx_data_n = FMC1_LPC_LA00_CC_N;
	assign  FMC1_LPC_LA01_CC_P = rx_busy_n;

	// tx
	assign tx_busy_n = FMC1_LPC_LA01_CC_N;
	assign FMC1_LPC_LA02_P = tx_data_n;
	assign FMC1_LPC_LA02_N = tx_clk_n;

    // East   
	// rx
	assign  rx_clk_e  = FMC1_LPC_LA03_P;
	assign  rx_data_e =  FMC1_LPC_LA03_N;
	assign  FMC1_LPC_LA04_P = rx_busy_e;

	// tx
	assign  tx_busy_e = FMC1_LPC_LA04_N;
	assign  FMC1_LPC_LA05_P = tx_data_e;
	assign  FMC1_LPC_LA05_N = tx_clk_e;

    // South 
	// rx
	assign  rx_clk_s  =  FMC1_LPC_LA06_P;
	assign  rx_data_s = FMC1_LPC_LA06_N;
	assign  FMC1_LPC_LA07_P = rx_busy_s;

	// tx
	assign  tx_busy_s = FMC1_LPC_LA07_N;
	assign  FMC1_LPC_LA08_P = tx_data_s;
	assign  FMC1_LPC_LA08_N = tx_clk_s;

    // West 
	// rx
	assign  rx_clk_w  = FMC1_LPC_LA20_P;
	assign  rx_data_w = FMC1_LPC_LA20_N;
	assign  FMC1_LPC_LA21_P = rx_busy_w;

	//tx
	assign  tx_busy_w = FMC1_LPC_LA21_N;
	assign  FMC1_LPC_LA22_P = tx_data_w;
	assign  FMC1_LPC_LA22_N = tx_clk_w;

                        
	wire [`ADDR_SZ-1:0] id;
	    
	wire reset, reset_pin, reset_btn;
	
	assign reset_pin = (id == 0) ? 0: FMC1_LPC_LA27_N;
	
	assign reset_btn = SW7;
	
	assign FMC1_LPC_LA23_N = reset_btn;
			
	assign reset = reset_btn | reset_pin; 
	
	

	assign id = {3'b0, DIP_SW1};
	 
	assign en = DIP_SW0;
	
	assign LEDS[0] = error;

	assign LEDS[1] = led; 
        
        assign LEDS[2] = reset; 
        
	assign LEDS[6:3] = id; 
        
        
	wire [`DIRECTIONS-1:0] rx_busy;
	
	wire [`DIRECTIONS-2:0] rx_data;
	
	wire [`DIRECTIONS-2:0] rx_clk;
	
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
	
	assign rx_clk = {rx_clk_n, rx_clk_e, rx_clk_s, rx_clk_w};
	
	(* dont_touch = "true" *)  assign {FMC1_LPC_LA24_P, FMC1_LPC_LA24_N, FMC1_LPC_LA25_P, FMC1_LPC_LA25_N} =  {rx_clk_n, rx_clk_e, rx_clk_s, rx_clk_w};
	
	wire tx_clk;
	
	assign tx_clk_n = tx_clk;
	assign tx_clk_e = tx_clk;
	assign tx_clk_s = tx_clk;
	assign tx_clk_w = tx_clk;
	
	
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
		      .wclk(rx_clk), 
		      .clk_fw(tx_clk),
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
		      
		      
		      
// 	  reg [31:0] counterx;
	  reg  toggling;
	  

	  
	  assign LEDS[7]=toggling;
	  
	   always @(posedge clk) begin
	
		if (reset)  begin
			toggling <=0;
		end
			
		else 
	  	    if (source_data[`PL_SZ + `ADDR_SZ - 1:`ADDR_SZ] > 100000-1 & source_valid)  
			  toggling <= !toggling;

	    end
	

	
endmodule
