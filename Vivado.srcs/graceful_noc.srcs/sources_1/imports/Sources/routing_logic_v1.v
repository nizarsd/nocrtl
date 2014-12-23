//----------------------------------------------------
// routing logic - parallel routing and arbitration for each channel
// Nizar Dahir 2014
//----------------------------------------------------

(* dont_touch = "true" *) module routing_logic (id,	clk, reset,
			n_item_in, n_read, n_empty, n_item_out, n_ena, n_busy,
			e_item_in, e_read, e_empty, e_item_out, e_ena, e_busy,
			s_item_in, s_read, s_empty, s_item_out, s_ena, s_busy,
			w_item_in, w_read, w_empty, w_item_out, w_ena, w_busy,
			l_item_in, l_read, l_empty, l_item_out, l_ena, l_busy
			);
			
	`include "constants.v"
//	parameter id=-1;
	
	
	input [`ADDR_SZ-1:0] id;
	
	input clk, reset;
	
	input  n_empty, e_empty, s_empty, w_empty, l_empty; 
	
	input  n_busy,  e_busy,  s_busy,  w_busy,  l_busy;
		
	output n_read,  e_read,  s_read,  w_read,  l_read;
	
	output n_ena,   e_ena,   s_ena,   w_ena,   l_ena;
	
	
	input  [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] n_item_in, e_item_in, s_item_in, w_item_in, l_item_in;
	
	output [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] n_item_out, e_item_out, s_item_out, w_item_out, l_item_out;
	
	wire [`ADDR_SZ-1:0] n_table_addr, e_table_addr, s_table_addr, w_table_addr, l_table_addr;
	
	wire [`BITS_DIR-1:0]  n_table_data, e_table_data, s_table_data, w_table_data, l_table_data ;
	
	//wire request [`DIRECTIONS-1:0] [`DIRECTIONS-1:0]
	//wire grant   [`DIRECTIONS-1:0] [`DIRECTIONS-1:0]
	
	wire e_n_req, s_n_req, w_n_req, l_n_req;
	wire n_e_req, s_e_req, w_e_req, l_e_req;
	wire n_s_req, e_s_req, w_s_req, l_s_req;
	wire n_w_req, e_w_req, s_w_req, l_w_req;
	wire n_l_req, e_l_req, s_l_req, w_l_req;
	
	wire e_n_gnt, s_n_gnt, w_n_gnt, l_n_gnt;
	wire n_e_gnt, s_e_gnt, w_e_gnt, l_e_gnt;
	wire n_s_gnt, e_s_gnt, w_s_gnt, l_s_gnt;
	wire n_w_gnt, e_w_gnt, s_w_gnt, l_w_gnt;
	wire n_l_gnt, e_l_gnt, s_l_gnt, w_l_gnt;
	
	wire e_n_gnt_v, s_n_gnt_v, w_n_gnt_v, l_n_gnt_v;
	wire n_e_gnt_v, s_e_gnt_v, w_e_gnt_v, l_e_gnt_v;
	wire n_s_gnt_v, e_s_gnt_v, w_s_gnt_v, l_s_gnt_v;
	wire n_w_gnt_v, e_w_gnt_v, s_w_gnt_v, l_w_gnt_v;
	wire n_l_gnt_v, e_l_gnt_v, s_l_gnt_v, w_l_gnt_v;
	
	
	assign n_table_addr = n_item_in[`ADDR_SZ-1:0];
	assign e_table_addr = e_item_in[`ADDR_SZ-1:0];
	assign s_table_addr = s_item_in[`ADDR_SZ-1:0];
	assign w_table_addr = w_item_in[`ADDR_SZ-1:0];
	assign l_table_addr = l_item_in[`ADDR_SZ-1:0];
	

	
	// requests to the north channel
	assign e_n_req = !e_empty & (e_table_data == `NORTH) & !n_busy;
	assign s_n_req = !s_empty & (s_table_data == `NORTH) & !n_busy;
	assign w_n_req = !w_empty & (w_table_data == `NORTH) & !n_busy;
	assign l_n_req = !l_empty & (l_table_data == `NORTH) & !n_busy;

	// requests to the east channel
	assign n_e_req = !n_empty & (n_table_data == `EAST) & !e_busy;
	assign s_e_req = !s_empty & (s_table_data == `EAST) & !e_busy;
	assign w_e_req = !w_empty & (w_table_data == `EAST) & !e_busy;
	assign l_e_req = !l_empty & (l_table_data == `EAST) & !e_busy;

	// requests to the south channel
	assign n_s_req = !n_empty & (n_table_data == `SOUTH) & !s_busy;
	assign e_s_req = !e_empty & (e_table_data == `SOUTH) & !s_busy;
	assign w_s_req = !w_empty & (w_table_data == `SOUTH) & !s_busy;
	assign l_s_req = !l_empty & (l_table_data == `SOUTH) & !s_busy;
	
	// requests to the west channel
	assign n_w_req = !n_empty & (n_table_data == `WEST) & !w_busy;
	assign e_w_req = !e_empty & (e_table_data == `WEST) & !w_busy;
	assign s_w_req = !s_empty & (s_table_data == `WEST) & !w_busy;
	assign l_w_req = !l_empty & (l_table_data == `WEST) & !w_busy;
	
	// requests to the local channel
	assign n_l_req = !n_empty & (n_table_data == `LOCAL) & !l_busy;
	assign e_l_req = !e_empty & (e_table_data == `LOCAL) & !l_busy;
	assign s_l_req = !s_empty & (s_table_data == `LOCAL) & !l_busy;
	assign w_l_req = !w_empty & (w_table_data == `LOCAL) & !l_busy;

	
	// enables of serial tx
	
	assign n_ena  = e_n_gnt_v | s_n_gnt_v | w_n_gnt_v | l_n_gnt_v;
	assign e_ena  = n_e_gnt_v | s_e_gnt_v | w_e_gnt_v | l_e_gnt_v;
	assign s_ena  = n_s_gnt_v | e_s_gnt_v | w_s_gnt_v | l_s_gnt_v;
	assign w_ena  = n_w_gnt_v | e_w_gnt_v | s_w_gnt_v | l_w_gnt_v;
	assign l_ena  = n_l_gnt_v | e_l_gnt_v | s_l_gnt_v | w_l_gnt_v;
		
    // reads from rx buffers
    assign n_read = n_e_gnt_v  | n_s_gnt_v  | n_w_gnt_v  | n_l_gnt_v ;
    assign e_read = e_n_gnt_v  | e_s_gnt_v  | e_w_gnt_v  | e_l_gnt_v ;
    assign s_read = s_n_gnt_v  | s_e_gnt_v  | s_w_gnt_v  | s_l_gnt_v ;
    assign w_read = w_n_gnt_v  | w_e_gnt_v  | w_s_gnt_v  | w_l_gnt_v ;
    assign l_read = l_n_gnt_v  | l_e_gnt_v  | l_s_gnt_v  | l_w_gnt_v ;
    
	assign n_e_gnt_v = n_e_gnt & !e_busy & !n_empty & (n_table_data == `EAST) ; 
	assign n_s_gnt_v = n_s_gnt & !s_busy & !n_empty & (n_table_data == `SOUTH) ;
	assign n_w_gnt_v = n_w_gnt & !w_busy & !n_empty & (n_table_data == `WEST) ;
	assign n_l_gnt_v = n_l_gnt & !l_busy & !n_empty & (n_table_data == `LOCAL) ;
	
	assign e_n_gnt_v = e_n_gnt & !n_busy & !e_empty & (e_table_data == `NORTH) ; 
	assign e_s_gnt_v = e_s_gnt & !s_busy & !e_empty & (e_table_data == `SOUTH) ;
	assign e_w_gnt_v = e_w_gnt & !w_busy & !e_empty & (e_table_data == `WEST) ; 
	assign e_l_gnt_v = e_l_gnt & !l_busy & !e_empty & (e_table_data == `LOCAL) ;
	
	assign s_n_gnt_v = s_n_gnt & !n_busy & !s_empty & (s_table_data == `NORTH); 
	assign s_e_gnt_v = s_e_gnt & !e_busy & !s_empty & (s_table_data == `EAST); 
	assign s_w_gnt_v = s_w_gnt & !w_busy & !s_empty & (s_table_data == `WEST); 
	assign s_l_gnt_v = s_l_gnt & !l_busy & !s_empty & (s_table_data == `LOCAL);
	
	assign w_n_gnt_v = w_n_gnt & !n_busy & !w_empty & (w_table_data == `NORTH);
	assign w_e_gnt_v = w_e_gnt & !e_busy & !w_empty & (w_table_data == `EAST);
	assign w_s_gnt_v = w_s_gnt & !s_busy & !w_empty & (w_table_data == `SOUTH);
	assign w_l_gnt_v = w_l_gnt & !l_busy & !w_empty & (w_table_data == `LOCAL);
	
	assign l_n_gnt_v = l_n_gnt & !n_busy & !l_empty & (l_table_data == `NORTH);
	assign l_e_gnt_v = l_e_gnt & !e_busy & !l_empty & (l_table_data == `EAST);
	assign l_s_gnt_v = l_s_gnt & !s_busy & !l_empty & (l_table_data == `SOUTH);
	assign l_w_gnt_v = l_w_gnt & !w_busy & !l_empty & (l_table_data == `WEST);


	// routing tables
	
	routing_table  rtable_n (id, reset, n_table_addr, n_table_data);
	
	routing_table  rtable_e (id, reset, e_table_addr, e_table_data);
	
	routing_table  rtable_s (id, reset, s_table_addr, s_table_data);
	
	routing_table  rtable_w (id, reset, w_table_addr, w_table_data);    
	    
	routing_table  rtable_l (id, reset, l_table_addr, l_table_data);    
	
	// arbitration
	
	rr_arbiter arbiter_n (clk, reset, l_n_req, e_n_req, s_n_req, w_n_req, l_n_gnt, e_n_gnt, s_n_gnt, w_n_gnt);
	
	rr_arbiter arbiter_e (clk, reset, l_e_req, n_e_req, s_e_req, w_e_req, l_e_gnt, n_e_gnt, s_e_gnt, w_e_gnt);
	
	rr_arbiter arbiter_s (clk, reset, l_s_req, n_s_req, e_s_req, w_s_req, l_s_gnt, n_s_gnt, e_s_gnt, w_s_gnt);
	
	rr_arbiter arbiter_w (clk, reset, l_w_req, n_w_req, e_w_req, s_w_req, l_w_gnt, n_w_gnt, e_w_gnt, s_w_gnt);
	
	rr_arbiter arbiter_l (clk, reset, s_l_req, n_l_req, e_l_req, w_l_req, s_l_gnt, n_l_gnt, e_l_gnt, w_l_gnt);
	
	
	// Craossbar switch

	assign n_item_out = e_n_gnt_v ? e_item_in : (s_n_gnt_v ? s_item_in : (w_n_gnt_v ? w_item_in : (l_n_gnt_v ? l_item_in : 40'bZ)));
	
	assign e_item_out = n_e_gnt_v ? n_item_in : (s_e_gnt_v ? s_item_in : (w_e_gnt_v ? w_item_in : (l_e_gnt_v ? l_item_in : 40'bZ)));
	
	assign s_item_out = n_s_gnt_v ? n_item_in : (e_s_gnt_v ? e_item_in : (w_s_gnt_v ? w_item_in : (l_s_gnt_v ? l_item_in : 40'bZ)));
	
	assign w_item_out = n_w_gnt_v ? n_item_in : (e_w_gnt_v ? e_item_in : (s_w_gnt_v ? s_item_in : (l_w_gnt_v ? l_item_in : 40'bZ)));
	
	assign l_item_out = n_l_gnt_v ? n_item_in : (e_l_gnt_v ? e_item_in : (s_l_gnt_v ? s_item_in : (w_l_gnt_v ? w_item_in : 40'bZ))); 	
	
endmodule


