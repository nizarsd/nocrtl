module routing_table(table_addr, table_data);

	parameter NODE_ID=0;
	parameter table_file ="";
// 	input reset;
	input [`ADDR_BITS-1:0] table_addr;
	output [`BITS_DIR-1:0] table_data;
	
	reg [`BITS_DIR-1:0] mem [`NUM_NODES-1:0];
	
	initial $readmemh(table_file, mem, 0, `NUM_NODES-1) ;
	assign table_data = mem[table_addr];

	//assign table_data = `DIR_LOCAL;

endmodule
