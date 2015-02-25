//----------------------------------------------------
// routing logic - parallel routing and arbitration for each channel
// Nizar Dahir 2014
//----------------------------------------------------

module routing_logic(	clk, reset,
			n_item_in, n_read, n_empty, n_item_out, n_ena, n_busy,
			e_item_in, e_read, e_empty, e_item_out, e_ena, e_busy,
			s_item_in, s_read, s_empty, s_item_out, s_ena, s_busy,
			w_item_in, w_read, w_empty, w_item_out, w_ena, w_busy,
			l_item_in, l_read, l_empty, l_item_out, l_ena, l_busy
			);
	parameter id=-1;
	
	parameter table_file ="";
	
	input clk, reset;
	
	input  n_empty, e_empty, s_empty, w_empty, l_empty; 
	
	input  n_busy,  e_busy,  s_busy,  w_busy,  l_busy;
		
	output n_read,  e_read,  s_read,  w_read,  l_read;
	
	output n_ena,   e_ena,   s_ena,   w_ena,   l_ena;
	
	
	input  [`PAYLOAD_SIZE+`ADDR_SZ-1:0] n_item_in, e_item_in, s_item_in, w_item_in, l_item_in;
	
	output [`PAYLOAD_SIZE+`ADDR_SZ-1:0] n_item_out, e_item_out, s_item_out, w_item_out, l_item_out;
	
	wire  /*reg*/ [`ADDR_SZ-1:0] n_table_addr, e_table_addr, s_table_addr, w_table_addr, l_table_addr;
	
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
	
	
	
// 	always @(posedge clk or posedge reset) begin
// 	
// 		if (reset) begin
// 		     n_table_addr <= 0;
// 		     e_table_addr <= 0;
// 		     s_table_addr <= 0;
// 		     w_table_addr <= 0;
// 		     l_table_addr <= 0;
// 		end else begin
// 		     n_table_addr <= n_item_in[`ADDR_SZ-1:0];
// 		     e_table_addr <= e_item_in[`ADDR_SZ-1:0];
// 		     s_table_addr <= s_item_in[`ADDR_SZ-1:0];
// 		     w_table_addr <= w_item_in[`ADDR_SZ-1:0];
// 		     l_table_addr <= l_item_in[`ADDR_SZ-1:0];
// 		end
// 	end
// 		
		
	
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
	assign n_l_req = !n_empty & (n_table_data == `LOCAL) & !l_busy & !n_l_gnt ;
	assign e_l_req = !e_empty & (e_table_data == `LOCAL) & !l_busy & !e_l_gnt ;
	assign s_l_req = !s_empty & (s_table_data == `LOCAL) & !l_busy & !s_l_gnt ;
	assign w_l_req = !w_empty & (w_table_data == `LOCAL) & !l_busy & !w_l_gnt ;

	
	// enables of serial tx
	
	assign n_ena = e_n_gnt_v | s_n_gnt_v | w_n_gnt_v | l_n_gnt_v;
	
	assign e_ena = n_e_gnt_v | s_e_gnt_v | w_e_gnt_v | l_e_gnt_v;
	
	assign s_ena = n_s_gnt_v | e_s_gnt_v | w_s_gnt_v | l_s_gnt_v;
	
	assign w_ena = n_w_gnt_v | e_w_gnt_v | s_w_gnt_v | l_w_gnt_v;
	
	assign l_ena = n_l_gnt_v | e_l_gnt_v | s_l_gnt_v | w_l_gnt_v;
	

// 	assign n_ena = (e_n_gnt & !e_empty | s_n_gnt & !s_empty | w_n_gnt & !w_empty | l_n_gnt & !l_empty) & !n_busy;
// 	
// 	assign e_ena = (n_e_gnt & !n_empty | s_e_gnt & !s_empty | w_e_gnt & !w_empty | l_e_gnt & !l_empty) & !e_busy;
// 	
// 	assign s_ena = (n_s_gnt & !n_empty | e_s_gnt & !e_empty | w_s_gnt & !w_empty | l_s_gnt & !l_empty) & !s_busy;
// 	
// 	assign w_ena = (n_w_gnt & !n_empty | e_w_gnt & !e_empty | s_w_gnt & !s_empty | l_w_gnt & !l_empty) & !w_busy;
// 	
// 	assign l_ena = (n_l_gnt & !n_empty | e_l_gnt & !e_empty | s_l_gnt & !s_empty | w_l_gnt & !w_empty) & !l_busy;
	
	

        assign n_e_gnt_v = n_e_gnt & !e_busy & !n_empty;
	assign n_s_gnt_v = n_s_gnt & !s_busy & !n_empty;
        assign n_w_gnt_v = n_w_gnt & !w_busy & !n_empty;
        assign n_l_gnt_v = n_l_gnt & !l_busy & !n_empty;
        
        assign e_n_gnt_v = e_n_gnt & !n_busy & !e_empty; 
        assign e_s_gnt_v = e_s_gnt & !s_busy & !e_empty;
        assign e_w_gnt_v = e_w_gnt & !w_busy & !e_empty; 
        assign e_l_gnt_v = e_l_gnt & !l_busy & !e_empty;
	
	assign s_n_gnt_v = s_n_gnt & !n_busy & !s_empty; 
	assign s_e_gnt_v = s_e_gnt & !e_busy & !s_empty; 
	assign s_w_gnt_v = s_w_gnt & !w_busy & !s_empty; 
	assign s_l_gnt_v = s_l_gnt & !l_busy & !s_empty;
	
	assign w_n_gnt_v = w_n_gnt & !n_busy & !w_empty;
	assign w_e_gnt_v = w_e_gnt & !e_busy & !w_empty;
	assign w_s_gnt_v = w_s_gnt & !s_busy & !w_empty;
	assign w_l_gnt_v = w_l_gnt & !l_busy & !w_empty;
	
	assign l_n_gnt_v = l_n_gnt & !n_busy & !l_empty;
	assign l_e_gnt_v = l_e_gnt & !e_busy & !l_empty;
	assign l_s_gnt_v = l_s_gnt & !s_busy & !l_empty;
	assign l_w_gnt_v = l_w_gnt & !w_busy & !l_empty;

	
	

// 	// reads from rx buffers
// 	assign n_read = (n_e_gnt & !e_busy | n_s_gnt & !s_busy | n_w_gnt & !w_busy | n_l_gnt & !l_busy) & !n_empty;
// 	
// 	assign e_read = (e_n_gnt & !n_busy | e_s_gnt & !s_busy | e_w_gnt & !w_busy | e_l_gnt & !l_busy) & !e_empty;
// 	
// 	assign s_read = (s_n_gnt & !n_busy | s_e_gnt & !e_busy | s_w_gnt & !w_busy | s_l_gnt & !l_busy) & !s_empty;
// 	
// 	assign w_read = (w_n_gnt & !n_busy | w_e_gnt & !e_busy | w_s_gnt & !s_busy | w_l_gnt & !l_busy) & !w_empty;
// 	
// 	assign l_read = (l_n_gnt & !n_busy | l_e_gnt & !e_busy | l_s_gnt & !s_busy | l_w_gnt & !w_busy) & !l_empty;

	// reads from rx buffers
	assign n_read = n_e_gnt_v  | n_s_gnt_v  | n_w_gnt_v  | n_l_gnt_v ;
	
	assign e_read = e_n_gnt_v  | e_s_gnt_v  | e_w_gnt_v  | e_l_gnt_v ;
	
	assign s_read = s_n_gnt_v  | s_e_gnt_v  | s_w_gnt_v  | s_l_gnt_v ;
	
	assign w_read = w_n_gnt_v  | w_e_gnt_v  | w_s_gnt_v  | w_l_gnt_v ;
	
	assign l_read = l_n_gnt_v  | l_e_gnt_v  | l_s_gnt_v  | l_w_gnt_v ;
	
	

	// routing tables
	
	routing_table #(id,table_file) n_rtable (n_table_addr, n_table_data);

	routing_table #(id,table_file) e_rtable (e_table_addr, e_table_data);
	
	routing_table #(id,table_file) s_rtable (s_table_addr, s_table_data);
	
	routing_table #(id,table_file) w_rtable (w_table_addr, w_table_data);
	
	routing_table #(id,table_file) l_rtable (l_table_addr, l_table_data);
	
	// arbitration
	
	rr_arbiter n_arbiter (clk, reset, l_n_req, e_n_req, s_n_req, w_n_req, l_n_gnt, e_n_gnt, s_n_gnt, w_n_gnt);
	
	rr_arbiter e_arbiter (clk, reset, l_e_req, n_e_req, s_e_req, w_e_req, l_e_gnt, n_e_gnt, s_e_gnt, w_e_gnt);
	
	rr_arbiter s_arbiter (clk, reset, l_s_req, n_s_req, e_s_req, w_s_req, l_s_gnt, n_s_gnt, e_s_gnt, w_s_gnt);
	
	rr_arbiter w_arbiter (clk, reset, l_w_req, n_w_req, e_w_req, s_w_req, l_w_gnt, n_w_gnt, e_w_gnt, s_w_gnt);
	
	rr_arbiter l_arbiter (clk, reset, s_l_req, n_l_req, e_l_req, w_l_req, s_l_gnt, n_l_gnt, e_l_gnt,  w_l_gnt);
	
	
	// Craossbar switch
// 	assign n_item_out = e_n_gnt ? e_item_in : (s_n_gnt ? s_item_in : (w_n_gnt ? w_item_in : (l_item_in)));
// 	
// 	assign e_item_out = n_e_gnt ? n_item_in : (s_e_gnt ? s_item_in : (w_e_gnt ? w_item_in : (l_item_in)));
// 	
// 	assign s_item_out = n_s_gnt ? n_item_in : (e_s_gnt ? e_item_in : (w_s_gnt ? w_item_in : (l_item_in)));
// 	
// 	assign w_item_out = n_w_gnt ? n_item_in : (e_w_gnt ? e_item_in : (s_w_gnt ? s_item_in : (l_item_in)));
// 	
// 	assign l_item_out = n_l_gnt ? n_item_in : (e_l_gnt ? e_item_in : (s_l_gnt ? s_item_in : (w_item_in)));

	assign n_item_out = e_n_gnt_v ? e_item_in : (s_n_gnt_v ? s_item_in : (w_n_gnt_v ? w_item_in : (l_n_gnt_v ? l_item_in : 0)));
	
	assign e_item_out = n_e_gnt_v ? n_item_in : (s_e_gnt_v ? s_item_in : (w_e_gnt_v ? w_item_in : (l_e_gnt_v ? l_item_in : 0)));
	
	assign s_item_out = n_s_gnt_v ? n_item_in : (e_s_gnt_v ? e_item_in : (w_s_gnt_v ? w_item_in : (l_s_gnt_v ? l_item_in : 0)));
	
	assign w_item_out = n_w_gnt_v ? n_item_in : (e_w_gnt_v ? e_item_in : (s_w_gnt_v ? s_item_in : (l_w_gnt_v ? l_item_in : 0)));
	
	assign l_item_out = n_l_gnt_v ? n_item_in : (e_l_gnt_v ? e_item_in : (s_l_gnt_v ? s_item_in : (w_l_gnt_v ? w_item_in : 0))); 	
	
endmodule


