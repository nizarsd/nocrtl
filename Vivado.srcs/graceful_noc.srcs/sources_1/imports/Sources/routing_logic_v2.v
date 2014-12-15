//----------------------------------------------------
// routing logic - parallel routing and arbitration for each channel
// Nizar Dahir 2014
//----------------------------------------------------
module routing_logic(	id, clk, reset,
			n_item_in, n_read, n_empty, n_item_out, n_ena, n_busy,
			e_item_in, e_read, e_empty, e_item_out, e_ena, e_busy,
			s_item_in, s_read, s_empty, s_item_out, s_ena, s_busy,
			w_item_in, w_read, w_empty, w_item_out, w_ena, w_busy,
			l_item_in, l_read, l_empty, l_item_out, l_ena, l_busy
			);
	`include "constants.v"
// 	`include "fifo.v"
// 	`include "routing_logic_v2.v"
// 	`include "par_rx_logic.v"
//	`include "routing_table.v"	
//	`include "rr_arbiter.v"
// 	`include "ch_rx_logic.v"
// 	`include "NI_v1.v"
// 	`include "dclk_rx.v"
// 	`include "dclk_tx.v"
// 	`include "async_router.v"

// 	parameter id=-1;
	
// 	parameter table_file ="";

	input [`ADDR_SZ-1:0] id;
	
	input clk, reset;
	
	input  n_empty, e_empty, s_empty, w_empty, l_empty; 
	
	input  n_busy,  e_busy,  s_busy,  w_busy,  l_busy;
		
	output n_read,  e_read,  s_read,  w_read,  l_read;
	
	output n_ena,   e_ena,   s_ena,   w_ena,   l_ena;
	
	
	input  [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] n_item_in, e_item_in, s_item_in, w_item_in, l_item_in;
	
	output [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] n_item_out, e_item_out, s_item_out, w_item_out, l_item_out;
	
	wire [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] item_in [0:`DIRECTIONS-1];
	
	wire [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] item_out [0:`DIRECTIONS-1];
	
	wire [0:`DIRECTIONS-1] ena;
	
	wire [0:`DIRECTIONS-1] busy;
	
	wire [0:`DIRECTIONS-1] read;
	
	wire [0:`DIRECTIONS-1] empty;
	
	assign empty = {n_empty, e_empty, s_empty, w_empty, l_empty}; 	
	assign busy  = {n_busy,  e_busy,  s_busy,  w_busy,  l_busy};
	
	assign {n_read,  e_read,  s_read,  w_read,  l_read} = read;
	assign {n_ena,   e_ena,   s_ena,   w_ena,   l_ena}  = ena;
	
	assign item_in[`NORTH] = n_item_in;
	assign item_in[`EAST]  = e_item_in;
	assign item_in[`SOUTH] = s_item_in;
	assign item_in[`WEST]  = w_item_in;
	assign item_in[`LOCAL] = l_item_in;
	
	assign n_item_out = item_out[`NORTH];
	assign e_item_out = item_out[`EAST]; 
	assign s_item_out = item_out[`SOUTH]; 
	assign w_item_out = item_out[`WEST]; 
	assign l_item_out = item_out[`LOCAL];
	
	wire  [`ADDR_SZ-1:0] table_addr [0:`DIRECTIONS-1];
	
	wire [`BITS_DIR-1:0]  table_data [0:`DIRECTIONS-1];
	
	wire [0:`DIRECTIONS-1] req[0:`DIRECTIONS-1];
		
	wire [0:`DIRECTIONS-1] gnt[0:`DIRECTIONS-1];
	
	wire [0:`DIRECTIONS-1] gnt_v[0:`DIRECTIONS-1];

    routing_table  rtable_n (id, reset, table_addr[`NORTH], table_data[`NORTH]);
    routing_table  rtable_e (id, reset, table_addr[`EAST], table_data[`EAST]);
    routing_table  rtable_s (id, reset, table_addr[`SOUTH], table_data[`SOUTH]);
    routing_table  rtable_w (id, reset, table_addr[`WEST], table_data[`WEST]);	
	
	genvar i,j;

	generate
	
	  for(i=0; i<`DIRECTIONS; i=i+1) begin: table_addresses
		assign table_addr[i] = item_in[i][`ADDR_SZ-1:0];
	  end
	  
	  // routing tables

	  for(i=0; i<`DIRECTIONS; i=i+1) begin: rtables
	      routing_table  rtable_w (id, reset, table_addr[i], table_data[i]);
	  
	  end
	  
	  // tx channel enables  and rx channel reads
  	  for(i=0; i<`DIRECTIONS; i=i+1) begin: enables
  	  
		    assign gnt_v[i][i] = 0;
		    
		    assign ena[i]  =  
				      gnt_v[`NORTH][i] | 
				      gnt_v[`EAST] [i] | 
				      gnt_v[`SOUTH][i] | 
				      gnt_v[`WEST] [i] | 
				      gnt_v[`LOCAL][i];
		    
    		    assign read[i] =  
				      gnt_v[i][`NORTH] |
				      gnt_v[i][`EAST]  |
				      gnt_v[i][`SOUTH] | 
				      gnt_v[i][`WEST]  | 
				      gnt_v[i][`LOCAL];

	  end

  	  
	  // requests to arbitration
	  for(i=0; i<`DIRECTIONS; i=i+1) begin: reqs
	      for(j=0; j<`DIRECTIONS; j=j+1) begin: reqs

		      if (j!=i)  assign req[j][i] = !empty[j] & (table_data[j] == i) & !busy[i];

	      end
	  end
	  
	  // valid grants
	  for(i=0; i<`DIRECTIONS; i=i+1) begin: gnts
	      for(j=0; j<`DIRECTIONS; j=j+1) begin: gnts

		      if (j!=i)      assign gnt_v[i][j] = gnt[i][j] & !busy[j] & !empty[i] & (table_data[i] == j);

	      end
	  end
	 
	endgenerate

	

	
	// arbitration
	
	rr_arbiter n_arbiter (clk, reset,
			      req[`LOCAL][`NORTH], req[`EAST][`NORTH], req[`SOUTH][`NORTH], req[`WEST][`NORTH],
			      gnt[`LOCAL][`NORTH], gnt[`EAST][`NORTH], gnt[`SOUTH][`NORTH], gnt[`WEST][`NORTH]
			      );
	
	rr_arbiter e_arbiter (clk, reset, 
			      req[`LOCAL][`EAST], req[`NORTH][`EAST], req[`SOUTH][`EAST], req[`WEST][`EAST],
			      gnt[`LOCAL][`EAST], gnt[`NORTH][`EAST], gnt[`SOUTH][`EAST], gnt[`WEST][`EAST]); 
					   	
	rr_arbiter s_arbiter (clk, reset, 
			      req[`LOCAL][`SOUTH], req[`NORTH][`SOUTH], req[`EAST][`SOUTH], req[`WEST][`SOUTH],
			      gnt[`LOCAL][`SOUTH], gnt[`NORTH][`SOUTH], gnt[`EAST][`SOUTH], gnt[`WEST][`SOUTH]
			      );
	
	rr_arbiter w_arbiter (clk, reset, 
			      req[`LOCAL][`WEST], req[`NORTH][`WEST], req[`EAST][`WEST], req[`SOUTH][`WEST],
			      gnt[`LOCAL][`WEST], gnt[`NORTH][`WEST], gnt[`EAST][`WEST], gnt[`SOUTH][`WEST]
			      );
	
	rr_arbiter l_arbiter (clk, reset, 
			      req[`SOUTH][`LOCAL], req[`NORTH][`LOCAL], req[`EAST][`LOCAL], req[`WEST][`LOCAL],
			      gnt[`SOUTH][`LOCAL], gnt[`NORTH][`LOCAL], gnt[`EAST][`LOCAL], gnt[`WEST][`LOCAL] 
			      );
	
	
	// Craossbar switch
	
	assign item_out[`NORTH] = 
				  gnt_v[`EAST][`NORTH] ?  e_item_in : (
				  gnt_v[`SOUTH][`NORTH] ? s_item_in : (
				  gnt_v[`WEST][`NORTH]  ? w_item_in : (
				  gnt_v[`LOCAL][`NORTH] ? l_item_in : 
				  0 )));
	
	assign item_out[`EAST]  = 
				  gnt_v[`NORTH][`EAST] ? n_item_in : (
				  gnt_v[`SOUTH][`EAST] ? s_item_in : (
				  gnt_v[`WEST][`EAST]  ? w_item_in : (
				  gnt_v[`LOCAL][`EAST] ? l_item_in : 
				  0)));
	
	assign item_out[`SOUTH] = 
				  gnt_v[`NORTH][`SOUTH] ? n_item_in : (
				  gnt_v[`EAST][`SOUTH]  ? e_item_in : (
				  gnt_v[`WEST][`SOUTH]  ? w_item_in : (
				  gnt_v[`LOCAL][`SOUTH] ? l_item_in : 
				  0)));
	
	assign item_out[`WEST]  = 
				  gnt_v[`NORTH][`WEST] ? n_item_in : (
				  gnt_v[`EAST][`WEST]  ? e_item_in : (
				  gnt_v[`SOUTH][`WEST] ? s_item_in : (
				  gnt_v[`LOCAL][`WEST] ? l_item_in : 
				  0)));
	
	assign item_out[`LOCAL] = 
				  gnt_v[`NORTH][`LOCAL] ? n_item_in : (
				  gnt_v[`EAST][`LOCAL]  ? e_item_in : (
				  gnt_v[`SOUTH][`LOCAL] ? s_item_in : (
				  gnt_v[`WEST][`LOCAL]  ? w_item_in : 
				  0))); 	
	
endmodule


