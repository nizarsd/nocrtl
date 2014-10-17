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
	
	
	input  [`PAYLOAD_SIZE+`ADDR_BITS-1:0] n_item_in, e_item_in, s_item_in, w_item_in, l_item_in;
	
	output [`PAYLOAD_SIZE+`ADDR_BITS-1:0] n_item_out, e_item_out, s_item_out, w_item_out, l_item_out;
	
	wire [`ADDR_BITS-1:0] n_table_addr, e_table_addr, s_table_addr, w_table_addr, l_table_addr;
	
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
	
	assign n_table_addr = n_item_in[`ADDR_BITS-1:0];
	assign e_table_addr = e_item_in[`ADDR_BITS-1:0];
	assign s_table_addr = s_item_in[`ADDR_BITS-1:0];
	assign w_table_addr = w_item_in[`ADDR_BITS-1:0];
	assign l_table_addr = l_item_in[`ADDR_BITS-1:0];
	

	
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
	
	assign n_ena = (e_n_gnt | s_n_gnt | w_n_gnt | l_n_gnt) & !n_busy;
	
	assign e_ena = (n_e_gnt | s_e_gnt | w_e_gnt | l_e_gnt) & !e_busy;
	
	assign s_ena = (n_s_gnt | e_s_gnt | w_s_gnt | l_s_gnt) & !s_busy;
	
	assign w_ena = (n_w_gnt | e_w_gnt | s_w_gnt | l_w_gnt) & !w_busy;
	
	assign l_ena = (n_l_gnt | e_l_gnt | s_l_gnt | w_l_gnt) & !l_busy;
	

	// reads from rx buffers
	assign n_read = n_e_gnt & !e_busy | n_s_gnt & !s_busy | n_w_gnt & !w_busy | n_l_gnt & !l_busy;
	
	assign e_read = e_n_gnt & !n_busy | e_s_gnt & !s_busy | e_w_gnt & !w_busy | e_l_gnt & !l_busy;
	
	assign s_read = s_n_gnt & !n_busy | s_e_gnt & !e_busy | s_w_gnt & !w_busy | s_l_gnt & !l_busy;
	
	assign w_read = w_n_gnt & !n_busy | w_e_gnt & !e_busy | w_s_gnt & !s_busy | w_l_gnt & !l_busy;
	
	assign l_read = l_n_gnt & !n_busy | l_e_gnt & !e_busy | l_s_gnt & !s_busy | l_w_gnt & !w_busy;


	// routing tables
	
	routing_table #(id,table_file) n_rtable (n_table_addr, n_table_data);

	routing_table #(id,table_file) e_rtable (e_table_addr, e_table_data);
	
	routing_table #(id,table_file) s_rtable (s_table_addr, s_table_data);
	
	routing_table #(id,table_file) w_rtable (w_table_addr, w_table_data);
	
	routing_table #(id,table_file) l_rtable (l_table_addr, l_table_data);
	
	// arbitration
	
	rr_arbiter n_arbiter (clk, reset, e_n_req, s_n_req, w_n_req, l_n_req, e_n_gnt, s_n_gnt, w_n_gnt, l_n_gnt);
	
	rr_arbiter e_arbiter (clk, reset, n_e_req, s_e_req, w_e_req, l_e_req, n_e_gnt, s_e_gnt, w_e_gnt, l_e_gnt);
	
	rr_arbiter s_arbiter (clk, reset, n_s_req, e_s_req, w_s_req, l_s_req, n_s_gnt, e_s_gnt, w_s_gnt, l_s_gnt);
	
	rr_arbiter w_arbiter (clk, reset, n_w_req, e_w_req, s_w_req, l_w_req, n_w_gnt, e_w_gnt, s_w_gnt, l_w_gnt);
	
	rr_arbiter l_arbiter (clk, reset, n_l_req, e_l_req, s_l_req, w_l_req, n_l_gnt, e_l_gnt, s_l_gnt, w_l_gnt);
	
	
	// Craossbar switch
	assign n_item_out = e_n_gnt ? e_item_in : (s_n_gnt ? s_item_in : (w_n_gnt ? w_item_in : (l_item_in)));
	
	assign e_item_out = n_e_gnt ? n_item_in : (s_e_gnt ? s_item_in : (w_e_gnt ? w_item_in : (l_item_in)));
	
	assign s_item_out = n_s_gnt ? n_item_in : (e_s_gnt ? e_item_in : (w_s_gnt ? w_item_in : (l_item_in)));
	
	assign w_item_out = n_w_gnt ? n_item_in : (e_w_gnt ? e_item_in : (s_w_gnt ? s_item_in : (l_item_in)));
	
	assign l_item_out = n_l_gnt ? n_item_in : (e_l_gnt ? e_item_in : (s_l_gnt ? s_item_in : (w_item_in)));
	
	
endmodule


