
module tx_logic (item_in, read, empty, table_addr, table_data, item_out, n_ena, n_busy, s_ena, s_busy, e_ena, e_busy, w_ena, w_busy, l_ena, l_busy);

	input empty, n_busy, s_busy, e_busy, w_busy, l_busy;
	
	output read, s_ena, n_ena, e_ena, w_ena, l_ena;
	
	input [`PAYLOAD_SIZE+`ADDR_BITS-1:0] item_in;
	output [`PAYLOAD_SIZE+`ADDR_BITS-1:0] item_out;
	output [`ADDR_BITS-1:0] table_addr;
	input [`BITS_DIR-1:0] table_data;
	
	assign table_addr = item_in[`ADDR_BITS-1:0];
	
	assign item_out = item_in;

	assign n_ena = !empty & (table_data == `NORTH) & !n_busy;
	assign s_ena = !empty & (table_data == `SOUTH) & !s_busy;
	assign e_ena = !empty & (table_data == `EAST)  & !e_busy;
	assign w_ena = !empty & (table_data == `WEST)  & !w_busy;
	assign l_ena = !empty & (table_data == `LOCAL)  & !l_busy;

	assign read = n_ena | s_ena | e_ena | w_ena | l_ena;

endmodule

